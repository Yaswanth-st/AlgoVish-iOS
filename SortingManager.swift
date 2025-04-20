//
//  SortingManager.swift
//  DataiO
//
//  Created by student_07 on 21/02/25.
//


import SwiftUI

@MainActor
class SortingManager: ObservableObject {
    @Published var numbers: [Int] = []
    @Published var sortingInProgress = false
    @Published var highlightedIndices: (Int?, Int?) = (nil, nil)
    @Published var comparisonText: String = ""
    
    func resetNumbers() {
        numbers = []
        sortingInProgress = false
        highlightedIndices = (nil, nil)
        comparisonText = ""
    }
    
    func addNumber(_ num: Int) {
        if numbers.count < 10 {
            numbers.append(num)
        }
    }
    
    func performBubbleSort() {
        guard !sortingInProgress else { return }
        sortingInProgress = true
        comparisonText = "Starting Bubble Sort..."

        var arr = numbers
        let n = arr.count
        var swaps: [(Int, Int)] = []

        for i in 0..<n {
            for j in 0..<n - i - 1 {
                highlightedIndices = (j, j + 1)
                comparisonText = "Comparing \(arr[j]) and \(arr[j + 1])"
                if arr[j] > arr[j + 1] {
                    swaps.append((j, j + 1))
                    arr.swapAt(j, j + 1)
                }
            }
        }
        Task { await animateSorting(swaps: swaps) }
    }
    
    func performSelectionSort() {
        guard !sortingInProgress else { return }
        sortingInProgress = true
        comparisonText = "Starting Selection Sort..."

        var arr = numbers
        let n = arr.count
        var swaps: [(Int, Int)] = []

        for i in 0..<n {
            var minIndex = i
            for j in i + 1..<n {
                highlightedIndices = (i, j)
                comparisonText = "Comparing \(arr[minIndex]) and \(arr[j])"
                if arr[j] < arr[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                swaps.append((i, minIndex))
                arr.swapAt(i, minIndex)
            }
        }
        Task { await animateSorting(swaps: swaps) }
    }
    
    func performMergeSort() {
        guard !sortingInProgress else { return }
        sortingInProgress = true
        comparisonText = "Starting Merge Sort..."
        
        Task {
            let sortedArray = await mergeSort(numbers)
            numbers = sortedArray
            sortingInProgress = false
            comparisonText = "Sorting Completed! 🎉"
        }
    }
    
    private func mergeSort(_ arr: [Int]) async -> [Int] {
        guard arr.count > 1 else { return arr }
        
        let mid = arr.count / 2
        let leftHalf = await mergeSort(Array(arr[..<mid]))
        let rightHalf = await mergeSort(Array(arr[mid...]))

        return await merge(leftHalf, rightHalf)
    }
    
    private func merge(_ left: [Int], _ right: [Int]) async -> [Int] {
        var sortedArray: [Int] = []
        var leftIndex = 0
        var rightIndex = 0

        while leftIndex < left.count && rightIndex < right.count {
            highlightedIndices = (leftIndex, rightIndex)
            await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))

            if left[leftIndex] < right[rightIndex] {
                sortedArray.append(left[leftIndex])
                leftIndex += 1
            } else {
                sortedArray.append(right[rightIndex])
                rightIndex += 1
            }
        }

        sortedArray.append(contentsOf: left[leftIndex...])
        sortedArray.append(contentsOf: right[rightIndex...])
        return sortedArray
    }

    private func animateSorting(swaps: [(Int, Int)]) async {
        guard !swaps.isEmpty else {
            sortingInProgress = false
            comparisonText = "Sorting Completed! 🎉"
            return
        }

        var tempNumbers = numbers
        for (i, j) in swaps {
            await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
            
            self.highlightedIndices = (i, j)
            comparisonText = "Swapping \(tempNumbers[i]) and \(tempNumbers[j])"
            tempNumbers.swapAt(i, j)
            self.numbers = tempNumbers

            await Task.sleep(UInt64(0.5 * Double(NSEC_PER_SEC)))
            self.highlightedIndices = (nil, nil)
        }
        sortingInProgress = false
        comparisonText = "Sorting Completed! 🎉"
    }
}
