//
// Copyright © 2020 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

struct UTMApp: App {
    @State var data = UTMData()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(data)
                .onAppear {
                    appDelegate.data = data
                    Task {
                        try? await data.apiServer.start()
                    }
                }
                .onReceive(.vmSessionError) { notification in
                    if let message = notification.userInfo?["Message"] as? String {
                        data.showErrorAlert(message: message)
                    }
                }
        }.commands {
            VMCommands()
        }
        Settings {
            SettingsView()
        }
    }
}
