function createMaze(mazeWidth, mazeHeight) {
    
    //  Parametry ----------------------
    var posX = 1;
    var posY = 1;
    var maze = [];
    var direction = [];
    var moves = [];
    var end = false;
    //----------------------------------

    // Tworzenie macierzy --------------
    for (i = 0; i < mazeWidth; i++){
        maze[i] = [];
        for (j = 0; j < mazeHeight; j++){
            maze[i][j] = 0;
        }
    }
    //----------------------------------

    // Tworzenie Labirynu --------------
    while(!end){

        // Wybieranie mozliwego kierunku ---------------------------
        if (posY == 1 && posX == 1){
            direction = ['D','R'];
        }
        else if (posY == mazeWidth - 2 && posX == mazeHeight - 2){
            direction = ['U','L'];
        }
        else if (posY == 1){
            direction = ['D','R','L'];
        }
        else if (posY == mazeWidth - 2){
            direction = ['U','R','L'];
        }
        else if (posX == 1){
            direction = ['U','R','D'];
        }
        else if (posX == mazeHeight - 2){
            direction = ['U','L','D'];
        }
        else{
            direction = ['U','R','D','L'];
        }
        // ---------------------------------------------------------

        // Losowanie Kierunku --------------------------------------
        while (direction.length != 0){
            var random = Math.floor(Math.random() * direction.length);
            
            if(direction[random] == 'U' && maze[posY-2][posX] == 0){
                moves.push('U');
                break;
            }
            else if (direction[random] == 'R' && maze[posY][posX+2] == 0){
                moves.push('R');
                break;      
            }
            else if(direction[random] == 'D' && maze[posY+2][posX] == 0){
                moves.push('D');
                break;
            }
            else if(direction[random] == 'L' && maze[posY][posX-2] == 0){
                moves.push('L');
                break;
            }else{
                direction.splice(random, 1);
            }
        }
        // ---------------------------------------------------------

        if (direction.length != 0) {  // Ruch -----------------------------------
            switch(moves[moves.length - 1]){
                case 'U':
                    maze[posY][posX] = 1;
                    maze[posY-1][posX] = 1;
                    posY -= 2;
                    break;
                
                case 'R':
                    maze[posY][posX] = 1;
                    maze[posY][posX+1] = 1;
                    posX += 2;
                    break;
                
                case 'D':
                    maze[posY][posX] = 1;
                    maze[posY+1][posX] = 1;
                    posY += 2;
                    break;

                case 'L':
                    maze[posY][posX] = 1;
                    maze[posY][posX-1] = 1;
                    posX -= 2;
                    break;
            }
        } 
        else { // Powrot --------------------------------------------
            switch(moves[moves.length - 1]){
                case 'U':
                    maze[posY][posX] = 2;
                    maze[posY+1][posX] = 2;
                    posY += 2;
                    moves.pop();
                    break;
                
                case 'R':
                    maze[posY][posX] = 2;
                    maze[posY][posX-1] = 2;
                    posX -= 2;
                    moves.pop();
                    break;
                
                case 'D':
                    maze[posY][posX] = 2;
                    maze[posY-1][posX] = 2;
                    posY -= 2;
                    moves.pop();
                    break;

                case 'L':
                    maze[posY][posX] = 2;
                    maze[posY][posX+1] = 2;
                    posX += 2;
                    moves.pop();
                    break;
                default:
                    maze[posY][posX] = 2;
                    end = true;
                    break;
            }
        }
    }
    return maze;
}
