#
# CMakeLists.txt
#
# Copyright (C) 2018 by RStudio, Inc.
#
# Unless you have received this program directly from RStudio pursuant
# to the terms of a commercial license agreement with RStudio, then
# this program is licensed to you under the terms of version 3 of the
# GNU Affero General Public License. This program is distributed WITHOUT
# ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
# AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
#
#

project (SERVER_CORE)

# include files
file(GLOB_RECURSE SERVER_CORE_HEADER_FILES "*.h*")

# source files
set (SERVER_CORE_SOURCE_FILES
   http/SecureCookie.cpp
   RVersionsScanner.cpp
   SecureKeyFile.cpp
   sessions/SessionSignature.cpp
   system/Pam.cpp
)

# define server core include dir
set(SERVER_CORE_INCLUDE_DIRS ${SERVER_CORE_INCLUDE_DIRS} include)

# additional include dirs
include_directories(
   ${SERVER_CORE_INCLUDE_DIRS}
   ${CMAKE_CURRENT_BINARY_DIR}
   ${CORE_SOURCE_DIR}/include
)

# define shared library
add_library(rstudio-server-core STATIC ${SERVER_CORE_SOURCE_FILES} ${SERVER_CORE_HEADER_FILES})

# link dependencies
target_link_libraries(
   rstudio-server-core
   rstudio-core
   ${SERVER_CORE_SYSTEM_LIBRARIES}
)
