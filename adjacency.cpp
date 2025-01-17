#include <iostream>
#include <vector>

// Function to get the adjacent nodes of a given node in a 3D grid
std::vector<int> getAdjacentNodes(int nodeId, int xSize, int ySize, int zSize) {
    std::vector<int> adjacentNodes;
    int xySize = xSize * ySize;
    
    // Calculate the x, y, and z coordinates of the node
    int z = nodeId / xySize;
    int y = (nodeId % xySize) / xSize;
    int x = nodeId % xSize;

    // Lambda to check if the position is valid and add the node
    auto addNode = [&](int xCoord, int yCoord, int zCoord) {
        if (xCoord >= 0 && xCoord < xSize &&
            yCoord >= 0 && yCoord < ySize &&
            zCoord >= 0 && zCoord < zSize) {
            adjacentNodes.push_back(zCoord * xySize + yCoord * xSize + xCoord);
        }
    };

    // Add adjacent nodes if they are within bounds
    if (x > 0) addNode(x - 1, y, z); // Left
    if (x < xSize - 1) addNode(x + 1, y, z); // Right
    if (y > 0) addNode(x, y - 1, z); // Down
    if (y < ySize - 1) addNode(x, y + 1, z); // Up
    if (z > 0) addNode(x, y, z - 1); // Front
    if (z < zSize - 1) addNode(x, y, z + 1); // Back

    return adjacentNodes;
}

int main() {
    // Example usage:
    int nodeId = 12; // The node to find the adjacent nodes for
    int xSize = 3; // The size of the grid along the X-axis
    int ySize = 3; // The size of the grid along the Y-axis
    int zSize = 3; // The size of the grid along the Z-axis

    std::vector<int> adjacent = getAdjacentNodes(nodeId, xSize, ySize, zSize);

    std::cout << "Adjacent nodes of node " << nodeId << ": ";
    for (int node : adjacent) {
        std::cout << node << " ";
    }
    std::cout << std::endl;

    return 0;
}

