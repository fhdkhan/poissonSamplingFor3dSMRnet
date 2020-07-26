function validPoint = isValid(candidate,height,width,w,points,grid,r)
  validPoint = false;

  valid_x = (candidate(1)>=0) && (candidate(1) < width);
  valid_y = (candidate(2)>=0) && (candidate(2) < height);
  if valid_x && valid_y
    cellX = ceil(candidate(1)/w);
	cellY = ceil(candidate(2)/w);
		
	# Do not overwrite
    if grid(cellX,cellY) != 0
       	return
    endif
			
	searchStartX = max(1,cellX -2);
	searchEndX = min(cellX+2,size(grid,2));
	searchStartY = max(1,cellY -2);
	searchEndY = min(cellY+2,size(grid,1));
    
	for x = searchStartX:searchEndX
		for y = searchStartY:searchEndY
				pointIndex = grid(x,y);
				if (pointIndex-1 != -1)
					sqrDst = sum((ceil(candidate(1,:)) - points(pointIndex,:)).^2);
					if (sqrDst < r*r)
                		return
					endif
            	endif
		endfor
    endfor
    validPoint = true;
	return
  endif
endfunction