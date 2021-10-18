import Foundation
import SwiftUI

public struct KSPieChart: View {
    
    var dataPointsWithTitle: [(title: String, value: Double, colour: Color)] = []
    private var total : Double {
        let durations = dataPointsWithTitle.map { $0.value }
        return durations.reduce(0.0, +)
    }
    @State private var segments: [SegmentData] = []
    
    public init(dataPointsWithTitle: [(title: String, value: Double, colour: Color)] = []) {
        self.dataPointsWithTitle = dataPointsWithTitle
    }
    
    public var body: some View {
        GeometryReader { geoProxy in
            VStack {
                ZStack {
                    ForEach(0..<self.segments.count, id: \.self) { segIndex in
                        Segment(radius: geoProxy.size.width / 3, startAngle: self.segments[segIndex].startAngle, endAngle: self.segments[segIndex].endAngle)
                            .fill(self.dataPointsWithTitle[segIndex].colour)
                        
                    }
                    Circle()
                        .fill(Color(UIColor.systemBackground))
                        .frame(width: geoProxy.size.width / 2, height: geoProxy.size.width / 2)
                        .overlay(
                            VStack {
                                Text("Total - \(self.total, specifier: "%.f")")
                                    .bold()
                                    .padding([.leading, .trailing, .top])
                                    .multilineTextAlignment(.center)
                            }
                            .rotationEffect(.degrees(90))
                        )
                }
                .rotationEffect(.degrees(-90))
                .frame(height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                ForEach(0..<self.dataPointsWithTitle.count, id: \.self) { segIndex in
                    HStack {
                        Circle()
                            .fill(self.dataPointsWithTitle[segIndex].colour)
                            .frame(width: 10, height: 10)
                        HStack(alignment: .center) {
                            Text("\(self.dataPointsWithTitle[segIndex].title)")
                            Spacer()
                            HStack {
                                Text("\(self.dataPointsWithTitle[segIndex].value, specifier: "%.2f")")
                                    .foregroundColor(.secondary)
                                Text("(\(self.percentage(of: self.dataPointsWithTitle[segIndex].value), specifier: "%.2f")%)")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear(perform: {
            chartData()
        })
    }
    
    private func percentage(of duration: Double) -> Double {
        (duration / total) * 100.0
    }
    
    private func chartData() {
        var lastEndAngle = 0.0
        segments = []
        
        for data in self.dataPointsWithTitle {
            let percent = percentage(of: data.value)
            let angle = (360 / 100) * (percent)
            let segmentData = SegmentData(percentage: percent, startAngle: lastEndAngle, endAngle: lastEndAngle + angle)
            
            self.segments.append(segmentData)
            lastEndAngle += angle
        }
    }
    
}

fileprivate struct SegmentData {
    var percentage: Double
    var startAngle: Double
    var endAngle: Double
}

fileprivate struct Segment: Shape {
    
    var radius: CGFloat
    var startAngle: Double
    var endAngle: Double
    
    func path(in rect: CGRect) -> Path {
        var segmentPath = Path()
        segmentPath.move(to: CGPoint(x: rect.midX, y: rect.midY))
        segmentPath.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
        return segmentPath
    }

}
