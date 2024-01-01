#!/usr/bin/env bash

SCRIPT=$(realpath -s "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
echo "SCRIPTPATH=$SCRIPTPATH"
read BUILD_CONFIG < "${SCRIPTPATH}/sentinel_build_config.type"


if [[ ! $BUILD_CONFIG =~ ^(Debug|RelWithDebInfo)$ ]]; then
    echo "CONFIG is not Debug or RelWithDebInfo CONFIG=$BUILD_CONFIG"
    exit 1
fi

DESTINATION=windows

echo "run rsync"
rsync \
    -avz \
    --copy-links \
    --exclude 'vcpkg/' \
    --exclude '.git/' \
    --exclude '.github/' \
    --exclude '.vscode/' \
    --exclude '.clang-tidy' \
    --exclude 'compile_flags.txt' \
    --exclude 'CMakeLists.txt.user' \
    --exclude '*pyc' \
    --exclude '*__pycache__' \
    --exclude 'vcpkg_installed' \
    --exclude 'rust/target' \
    --exclude 'cscope*' \
    ./ \
    $DESTINATION:/c/users/Porebski/sentinel_rsync/ \
    --delete --force
    # --delete-excluded --force

RSYNC_EXIT_CODE=$?
if [[ $RSYNC_EXIT_CODE -ne 0 ]]; then
    read -p "rsync filed with code $RSYNC_EXIT_CODE"
    exit $RSYNC_EXIT_CODE
fi

if [[ "$1" == "sync" ]];then
    exit $RSYNC_EXIT_CODE
fi

branch_name="$(git symbolic-ref HEAD 2>/dev/null)" || branch_name="(unnamed branch)" # detached HEAD
branch_name=${branch_name##refs/heads/}

PRESET_NAME="dev"
BUILD_DIR="C:\Users\Porebski\build"
INSTALL_DIR="C:\Users\Porebski\install"
CONFIG_DIR="${INSTALL_DIR}\release"
if [[ $BUILD_CONFIG == "Debug" ]]; then CONFIG_DIR="${INSTALL_DIR}\debug"; fi

REMOVE_BUILD_DIR="Remove-Item -Path ${BUILD_DIR}\* -Exclude \"vcpkg_installed\" -Recurse -Force"
REMOVE_VCPKG_INSTALLED="Remove-Item -Path ${CONFIG_DIR}\vcpkg_installed -Recurse -Force"
COPY_CONFIG_TO_INSTALL_DIR="Copy-Item -Path ${CONFIG_DIR}\\${BUILD_CONFIG}\* -Destination ${CONFIG_DIR}"
CONFIGURE="cmake -DGIT_HASH=${branch_name} --preset ${PRESET_NAME}"

POWERSHELL_QUOTE="\"\"\""
BUILD="cmake --build --preset ${PRESET_NAME} --config ${BUILD_CONFIG} --target $2"
INSTALL="cmake --build --preset ${PRESET_NAME} --config ${BUILD_CONFIG} --target install"
CLEAN="cmake --build --preset ${PRESET_NAME} --target clean"
CHECK_IF_CIRCLE_DEP="2>&1 | %{\$ninja_output+=\$_;\$_}; if ( echo \$ninja_output | Select-String -Pattern ${POWERSHELL_QUOTE}dependency cycle${POWERSHELL_QUOTE} -SimpleMatch -Quiet)"
CHECK_DEPENDENCY_CIRCLE_AND_CLEAN_BUILD="${BUILD} ${CHECK_IF_CIRCLE_DEP} { ${CLEAN}; ${BUILD} } "
CHECK_DEPENDENCY_CIRCLE_AND_CLEAN_INSTALL="${INSTALL} ${CHECK_IF_CIRCLE_DEP} { ${CLEAN}; ${INSTALL} } "
if [[ "$3" == "local" ]]; then
    LOCAL_INSTALL="-$3 1"
fi
IS_DEBUG=0
if [[ $BUILD_CONFIG == "Debug" ]]; then IS_DEBUG=1; fi
INSTALL_AND_SEND="Invoke-Expression -Command ${POWERSHELL_QUOTE}C:\Users\Porebski\dotfiles\windows\install_and_send_to_cabinetPC.ps1 -rebuild 0 -name $2 -is_debug ${IS_DEBUG} ${LOCAL_INSTALL}${POWERSHELL_QUOTE}"
SEND="Invoke-Expression -Command ${POWERSHELL_QUOTE}C:\Users\Porebski\dotfiles\windows\send_to_cabinetPC.ps1 -name $2 -is_debug ${IS_DEBUG} ${LOCAL_INSTALL}${POWERSHELL_QUOTE}"

if [[ "$1" == "configure" ]]; then
    SENTINEL_BUILD_COMMAND="$REMOVE_BUILD_DIR;$CONFIGURE"
elif [[ "$1" == "build" ]]; then
    SENTINEL_BUILD_COMMAND=$CHECK_DEPENDENCY_CIRCLE_AND_CLEAN_BUILD
elif [[ "$1" == "release" ]]; then
    SENTINEL_BUILD_COMMAND=$CHECK_DEPENDENCY_CIRCLE_AND_CLEAN_BUILD
elif [[ "$1" == "install_old" ]]; then
    SENTINEL_BUILD_COMMAND=$INSTALL_AND_SEND
elif [[ "$1" == "install" ]]; then
    SENTINEL_BUILD_COMMAND="$CHECK_DEPENDENCY_CIRCLE_AND_CLEAN_INSTALL;$REMOVE_VCPKG_INSTALLED;$COPY_CONFIG_TO_INSTALL_DIR;$SEND"
fi

GO_TO_SRC_DIR="cd C:\Users\Porebski\sentinel_rsync"
ACTIVATE_PYTHON_ENV="Invoke-Expression -Command ${POWERSHELL_QUOTE}C:\Users\Porebski\python\Scripts\Activate.ps1${POWERSHELL_QUOTE}"
VCVARS_AND_PYTHON_ENV="powershell.exe -NoExit -Command \"&{Import-Module ${POWERSHELL_QUOTE}C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll${POWERSHELL_QUOTE}; Enter-VsDevShell 11f35a7b -SkipAutomaticLocation -DevCmdArguments ${POWERSHELL_QUOTE}-arch=x64 -host_arch=x64${POWERSHELL_QUOTE}; ${ACTIVATE_PYTHON_ENV}; ${GO_TO_SRC_DIR}; ${SENTINEL_BUILD_COMMAND}; exit }"

COMMAND="ssh $DESTINATION ${VCVARS_AND_PYTHON_ENV}"
echo $COMMAND
$COMMAND
