import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : MinesweeperGame = MinesweeperGame()
    @State var placeFlag: Bool = false
    @State private var time = 0
    @State private var gameStart = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ZStack {
            VStack {
                Text("Minesweeper").font(.system(size: 40, weight: .heavy, design: .monospaced)).padding(.vertical, 10)
                ZStack {
                    HStack {
                        Text("🕚 \(time)").bold().padding(.horizontal, 40).font(.system(size: 30, design: .rounded))
                        Spacer()
                    }
                    HStack {
                        Button("🚩") {
                            placeFlag.toggle()
                        }.font(.system(size: 25)).background(
                            Rectangle().foregroundColor(Color(.systemGray3)).frame(width: 40, height: 40).padding(.vertical, 1).border(Color(.systemGray2).gradient, width: 5).padding(.all, 1)).background(Rectangle().stroke(lineWidth: 10).foregroundColor(Color(.systemGray)).frame(width: 40, height: 40))
                        
                    }
                    HStack {
                        Spacer()
                        Text("💣 \(viewModel.numOfMines)").bold().padding(.horizontal, 40).font(.system(size: 30))
                    }
                }.padding(.vertical, 20).border(Color(.systemGray2).gradient, width: 5).background(Color(.systemGray3))
                Spacer()
            }
            VStack {
                LazyVGrid(columns: gridItems, spacing: 0) {
                    ForEach(viewModel.board ){ space in
                        spaceView(space: space).aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/).onTapGesture { withAnimation(.spring(duration: 1, bounce: 0.5).delay(0.3)){
                            gameStart = true
                            if(placeFlag) {
                                viewModel.placeFlag(space.id)
                            }
                            else if !space.flagPlaced{
                                viewModel.revealSpace(space.row, space.col)
                            }
                        }
                        }
                    }
                }
                Button(action: {
                    viewModel.reset()
                    time = 0
                    gameStart = false
                    
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                }).font(.system(size: 40))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color(.systemGray4)).onReceive(timer) { t in
            if gameStart && !viewModel.bombRevealed {
                time += 1
            }
        }
    }
}

struct spaceView: View {
    var space: Board.Space
    var body: some View {
        ZStack {
            
            let shape = Rectangle().foregroundColor(Color(.systemGray3)).frame(width: 40, height: 40).padding(.vertical, 1).border(Color(.systemGray2).gradient, width: 5).padding(.all, 1)
            let flag = Text("🚩").font(.system(size: 25)).background(shape)
            
            Text(space.content).font(.system(size: 30)).bold().scaleEffect(space.content == "💥" && space.revealed ? 1.5 : 1)
            Rectangle().stroke(lineWidth: 4.6).foregroundColor(Color(.systemGray)).frame(width: 40, height: 40)
            if (space.revealed) {
                shape.opacity(0)
            }
            else {
                shape.opacity(1)
            }
            if space.flagPlaced {
                flag.opacity(1)
            }
            else {
                flag.opacity(0)
            }
        }
    }
}
        

#Preview {
    ContentView(viewModel : MinesweeperGame())
}
