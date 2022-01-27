//
//  GridView.swift
//  SwiftUIGameOfLife
//
//  Created by Van Simmons on 5/31/20.
//  Copyright © 2020 ComputeCycles, LLC. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Grid
import GameOfLife

public struct GridView: View {
    let store: Store<GridState, GridState.Action>
    let configuration: Configuration
    @State private var lastPosition: Grid.Offset? = .none

    public init(
        store: Store<GridState, GridState.Action>,
        configuration: Configuration = Configuration()
    ) {
        self.store = store
        self.configuration = configuration
    }

    func cellWidth(for viewStore: ViewStore<GridState, GridState.Action>, g: GeometryProxy) -> CGFloat {
        g.frame(in: .local).size.width / CGFloat(viewStore.grid.size.cols)
    }

    func cellHeight(for viewStore: ViewStore<GridState, GridState.Action>, g: GeometryProxy) -> CGFloat {
        g.frame(in: .local).size.height / CGFloat(viewStore.grid.size.rows)
    }

    func lines(
        for viewStore: ViewStore<GridState, GridState.Action>,
        g: GeometryProxy
    ) -> some View {
        return Path { p in
            guard self.cellWidth(for: viewStore, g: g) > 5.0 else { return }
            (0 ... viewStore.grid.size.cols).forEach { i in
                p.move(to: CGPoint(
                    x: g.frame(in: .local).origin.x + self.cellWidth(for: viewStore, g: g) * CGFloat(i),
                    y: g.frame(in: .local).origin.y
                ))
                p.addLine(to: CGPoint(
                    x: g.frame(in: .local).origin.x + self.cellWidth(for: viewStore, g: g) * CGFloat(i),
                    y: g.frame(in: .local).origin.y + g.frame(in: .local).size.height
                ))
            }
            (0 ... viewStore.grid.size.rows).forEach { i in
                p.move(to: CGPoint(
                    x: g.frame(in: .local).origin.x - self.configuration.lineWidth/CGFloat(2.0),
                    y: g.frame(in: .local).origin.y + self.cellHeight(for: viewStore, g: g) * CGFloat(i)
                ))
                p.addLine(to: CGPoint(
                    x: g.frame(in: .local).origin.x + g.frame(in: .local).size.width + self.configuration.lineWidth/CGFloat(2.0),
                    y: g.frame(in: .local).origin.y + self.cellHeight(for: viewStore, g: g) * CGFloat(i)
                ))
            }
        }
        .stroke(Color("gridLine"), lineWidth: self.configuration.lineWidth)
    }

    func cells(
        for viewStore: ViewStore<GridState, GridState.Action>,
        g: GeometryProxy
    ) -> some View {
        ForEach (viewStore.grid.allOffsets, id: \.self) {
            viewStore.grid[$0.row][$0.col] == .empty
                ? nil
                : Cell(
                    offset: $0,
                    gridSize: viewStore.grid.size,
                    configuration: self.configuration,
                    gridRect: g.frame(in: .local),
                    cellState: viewStore.grid[$0.row][$0.col]
                )
        }
        .frame(
            width: g.size.width,
            height: g.size.height,
            alignment: .center
        )
        .offset(x: 0.0, y: 0.0)
    }

    func squareSize(for g: GeometryProxy) -> CGFloat {
        min(g.size.width, g.size.height) * 0.92
    }

    func cellWidthOffset(
        for viewStore: ViewStore<GridState, GridState.Action>,
        g: GeometryProxy
    ) -> CGFloat {
        (
            self.cellWidth(for: viewStore, g: g)
            - g.size.width
            - configuration.lineWidth
            - (configuration.inset * 2.0)
        ) / 2.0
    }

    func cellHeightOffset(
        for viewStore: ViewStore<GridState, GridState.Action>,
        g: GeometryProxy
    ) -> CGFloat {
        (
            self.cellHeight(for: viewStore, g: g)
            - g.size.height
            - configuration.lineWidth
            - (configuration.inset * 2.0)
        ) / 2.0
    }

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            GeometryReader { boundingBox in
                GeometryReader { g in
                    self.lines(for: viewStore, g: g)
                        .background(Color("gridBackground"))
                        .gesture(self.touchHandler(for: viewStore, geometry: g))
                    self.cells(for: viewStore, g: g)
                        .offset(
                            x: self.cellWidthOffset(for: viewStore, g: g),
                            y: self.cellHeightOffset(for: viewStore, g: g)
                        )
                }
                .frame(
                    width: self.squareSize(for: boundingBox),
                    height: self.squareSize(for: boundingBox),
                    alignment: .center
                )
                .offset(
                    x: (boundingBox.size.width - self.squareSize(for: boundingBox)) / 2.0,
                    y: (boundingBox.size.height - self.squareSize(for: boundingBox)) / 2.0
                )
            }
        }
    }
}

extension GridView {
    private func touchHandler(
        for viewStore: ViewStore<GridState, GridState.Action>,
        geometry g: GeometryProxy
    ) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let viewStore = viewStore
                guard let touchedCell = self.convert(value.location, viewStore: viewStore, geometry: g),
                    touchedCell.row != self.lastPosition?.row || touchedCell.col != self.lastPosition?.col
                    else { return }
                viewStore.send(.toggle(touchedCell.row, touchedCell.col))
                self.lastPosition = touchedCell
            }
            .onEnded { _ in
                self.lastPosition = .none
            }
    }
}

extension GridView {
    private func convert(
        _ touch: CGPoint,
        viewStore: ViewStore<GridState, GridState.Action>,
        geometry g: GeometryProxy
    ) -> Grid.Offset? {
        let touchY = touch.y - (configuration.lineWidth/2.0)
        let row = touchY / g.frame(in: .local).size.height * CGFloat(viewStore.grid.size.rows)

        let touchX = touch.x - (configuration.lineWidth/2.0)
        let col = touchX / g.frame(in: .local).size.width * CGFloat(viewStore.grid.size.cols)

        let pos = Grid.Offset(row: Int(row), col: Int(col))

        guard pos.row >= 0 && pos.row < viewStore.grid.size.rows
            && pos.col >= 0 && pos.col < viewStore.grid.size.cols
            else { return .none }

        return pos
    }
}

public extension GridView {
    struct Configuration {
        var inset: CGFloat
        var lineWidth: CGFloat
        var aliveColor: String
        var bornColor: String
        var diedColor: String
        var emptyColor: String

        public init(
            inset: CGFloat = 0.5,
            lineWidth: CGFloat = 1.0,
            aliveColor: String = "alive",
            bornColor: String = "born",
            diedColor: String = "died",
            emptyColor: String = "empty"
        ) {
            self.inset = inset
            self.lineWidth = lineWidth
            self.aliveColor = aliveColor
            self.bornColor = bornColor
            self.diedColor = diedColor
            self.emptyColor = emptyColor
        }

        func color(for cellState: CellState) -> String {
            switch cellState {
            case .alive: return aliveColor
            case .born:  return bornColor
            case .died:  return diedColor
            case .empty: return emptyColor
            }
        }
    }
}

extension GridView {
    struct Cell: View {
        var gridOffset: Grid.Offset
        var gridSize: Grid.Size
        var configuration: GridView.Configuration
        var gridRect: CGRect
        var cellState: CellState

        init(
            offset: Grid.Offset,
            gridSize: Grid.Size,
            configuration: GridView.Configuration,
            gridRect: CGRect,
            cellState: CellState
        ) {
            self.gridOffset = offset
            self.gridSize = gridSize
            self.configuration = configuration
            self.gridRect = gridRect
            self.cellState = cellState
        }

        var body: some View {
            Ellipse()
                .fill(Color(color))
                .frame(width: frame.width, height: frame.height)
                .offset(offset)
        }

        // MARK: Helper Methods
        var row: Int { gridOffset.row }
        var col: Int { gridOffset.col }

        var width: CGFloat {
            self.gridRect.size.width / CGFloat(gridSize.cols)
        }

        var height: CGFloat {
            self.gridRect.size.height / CGFloat(gridSize.rows)
        }

        var color: String {
            configuration.color(for: cellState)
        }

        var frame: CGSize {
            switch cellState {
            case .alive, .born, .died, .empty:
                return CGSize(
                    width: size(width),
                    height: size(height)
                )
            }
        }

        func size(_ cellDimension: CGFloat) -> CGFloat {
            cellDimension - configuration.lineWidth - (2.0 * configuration.inset)
        }

        var rect: CGRect {
            CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: size(width), height: size(height))
            )
        }

        var offset: CGSize {
            CGSize(
                width: origin(rect.origin.x, width, col),
                height: origin(rect.origin.y, height, row)
            )
        }

        func origin(_ start: CGFloat, _ increment: CGFloat, _ offset: Int) -> CGFloat {
            start
                + (increment * CGFloat(offset))
                + self.configuration.lineWidth / 2.0
                + self.configuration.inset
        }
    }
}
public struct GridView_Previews: PreviewProvider {
    static let previewState = GridState()
    public static var previews: some View {
        GeometryReader { g in
            GridView(
                store: Store(
                    initialState: previewState,
                    reducer: gridReducer,
                    environment: GridEnvironment()
                )
            )
        }
    }
}
