# LoveBFS

> BFS/DFS visualizations using Lua and LÖVE

## Installation and Running:

- make sure to have [LÖVE](https://love2d.org/) installed
- clone repo with `git clone https://github.com/plt3/LoveBFS`
- in project directory, run `love .`
- can change configuration variables/constants in [constants.lua](constants.lua)

## Usage:

- drag/click mouse to create walls (gray cells)
  - hold shift to erase
- double click mouse to set source (red cell), then double click again in another cell to set destination (green cell)
- once source and destination are set, press `return` to begin algorithm
- when algorithm is not running:
  - press `r` to clear algorithm's progression and found path
  - press `c` to clear entire grid
  - press `a` to toggle between BFS and DFS
