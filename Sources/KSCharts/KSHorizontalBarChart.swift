//
//  File.swift
//  
//
//  Created by Karthick Selvaraj on 30/10/21.
//

import Foundation
import SwiftUI

public struct KSHorizontalBarChartView: View {
    
    var dataPointsWithTitle: [(title: String, value: Double, colour: Color)] = []
    
    private var total: Double {
        dataPointsWithTitle.reduce(0) { result, point in
            result + point.value
        }
    }
    
    // MARK: - Init Methods
    
    public init(dataPointsWithTitle: [(title: String, value: Double, colour: Color)] = []) {
        self.dataPointsWithTitle = dataPointsWithTitle
    }
    
    // MARK: - View Body
    
    public var body: some View {
        ScrollView {
            GeometryReader { proxy in
                VStack(spacing: 10) {
                    ForEach(0..<dataPointsWithTitle.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(dataPointsWithTitle[index].title.capitalized)
                                .font(.caption)
                            HStack {
                                ZStack(alignment: .leading) {
                                    Image("dottedLine")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.secondary.opacity(0.3))
                                        .frame(height: 1, alignment: .center)
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(dataPointsWithTitle[index].colour)
                                        .frame(width: (proxy.size.width * 0.7) * CGFloat(normalizedValue(index: index)), alignment: .center)
                                }
                                HStack {
                                    Spacer()
                                    Text(dataPointsWithTitle[index].value.kmFormatted)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .truncationMode(.middle)
                                    Text("(\(dataPointsWithTitle[index].value.percentage(from: total), specifier: "%0.2f")%)")
                                        .font(.caption2)
                                        .bold()
                                        .layoutPriority(1)
                                }
                                .frame(width: proxy.size.width * 0.3)
                            }
                            .frame(height: 10)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    
    // MARK: - Custom methods
    
    private func normalizedValue(index: Int) -> Double {
        var allValues: [Double] {
            var values = [Double]()
            for point in dataPointsWithTitle {
                values.append(point.value)
            }
            return values
        }
        guard let max = allValues.max(), max != 0 else { return 1 }
        
        let currentPointValue = dataPointsWithTitle[index].value
        let scale = Double(currentPointValue)/Double(max)
        if currentPointValue == max && allValues.count != 1 {
            return scale - 0.03
        } else {
            return scale
        }
    }
    
}
