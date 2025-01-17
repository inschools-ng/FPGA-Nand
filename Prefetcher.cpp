#include <iostream>
#include <chrono>

// Precompute the adjacent nodes for each possible position in a 3x3x3 grid
void precomputeAdjacency(int adjacency[27][6]) {
    int dx[] = { -1, 1, 0, 0, 0, 0 };
    int dy[] = { 0, 0, -1, 1, 0, 0 };
    int dz[] = { 0, 0, 0, 0, -1, 1 };
    
    for (int x = 0; x < 3; ++x) {
        for (int y = 0; y < 3; ++y) {
            for (int z = 0; z < 3; ++z) {
                int index = x * 9 + y * 3 + z;
                for (int i = 0; i < 6; ++i) {
                    int newX = x + dx[i];
                    int newY = y + dy[i];
                    int newZ = z + dz[i];
                    
                    if (newX >= 0 && newX < 3 && newY >= 0 && newY < 3 && newZ >= 0 && newZ < 3) {
                        adjacency[index][i] = newX * 9 + newY * 3 + newZ;
                    } else {
                        adjacency[index][i] = -1; // Invalid index
                    }
                }
            }
        }
    }
}

// Function to access adjacent nodes
void accessAdjacentNodes(int nodeIndex, const int grid[27], const int adjacency[27][6]) {
    // Access the node itself
    int nodeValue = grid[nodeIndex];

    // Access all adjacent nodes
    for (int i = 0; i < 6; ++i) {
        int adjacentIndex = adjacency[nodeIndex][i];
        if (adjacentIndex != -1) {
            int adjacentValue = grid[adjacentIndex];
        }
    }
}

int main() {
    // Initialize a 3x3x3 grid with sample values
    int grid[27];
    for (int i = 0; i < 27; ++i) {
        grid[i] = i;
    }

    // Precompute adjacency information
    int adjacency[27][6];
    precomputeAdjacency(adjacency);

    // Access node 19 (corresponding to (1,1,1) in a 3x3x3 grid)
    int nodeIndex = 19;

    // Measure performance
    auto start = std::chrono::high_resolution_clock::now();

    for (int i = 0; i < 1000000; ++i) {
        accessAdjacentNodes(nodeIndex, grid, adjacency);
    }

    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> duration = end - start;

    std::cout << "Execution Time: " << duration.count() << " seconds" << std::endl;

    return 0;
}
