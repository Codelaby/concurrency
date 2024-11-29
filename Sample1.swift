import SwiftUI

struct AsyncAwaitGroupsDemo: View {
    var body: some View {
        VStack {
            
            Button("Sequential") {
                
                // Sequential process
                Task {
                    let item1 = await fetchItem(for: "1")
                    let item2 = await fetchItem(for: "2")
                    let item3 = await fetchItem(for: "3")

                    let items = [item1, item2, item3]

                    print("🏁 Finished processing all items: \(items)")
                }
            }

            Button("Parallel") {
                
                // Parallel process
                Task {
                    let items = await fetchItemsInParallelWithTaskGroup()
                    print("🏁 Finished processing all items: \(items)")
                }
            }

        }
    }

    
    private func fetchItem(for id: String) async -> String {
        print("▶️ Processing \(id)...")

        // Conditional to adjust wait time when the task is 2
        let secondsToWait = id == "2" ? 5 : 3

        try! await Task.sleep(for: .seconds(secondsToWait))
        print("✅ Completed \(id) in \(secondsToWait) seconds")
        return "Item \(id)"
    }

    private func fetchItemsInParallelWithTaskGroup() async -> [String] {
        let ids = ["1", "2", "3"]
        return await withTaskGroup(of: String.self) { taskGroup in
            var items = [String]()
            // For each id, a task for the group is created
            for identification in ids {
                taskGroup.addTask {
                    return await self.fetchItem(for: identification)
                }
            }
            for await item in taskGroup {
                items.append(item)
            }

            return items
        }
    }
}

#Preview {
    Text("Async await, sequential and parallel").font(.largeTitle.bold()).multilineTextAlignment(.center).padding(.horizontal)
    Spacer()

    AsyncAwaitGroupsDemo()
    
    Text("Check the console for results").font(.footnote)
    Spacer()
}

