function validPoint = isValid3(candidate,height,width,depth,w,points,grid,r)
  validPoint = false;

  valid_x = (candidate(1)>=0) && (candidate(1) < width);
  valid_y = (candidate(2)>=0) && (candidate(2) < height);
  valid_z = (candidate(3)>=0) && (candidate(3) < depth);
  if valid_x && valid_y && valid_z
    cellX = ceil(candidate(1)/w);
	cellY = ceil(candidate(2)/w);
	cellZ = ceil(candidate(3)/w);
		
	# Do not overwrite
    if grid(cellX,cellY,cellZ) != 0
       	return
    endif
			
	searchStartX = max(1,cellX -2);
	searchEndX = min(cellX+2,size(grid,2));
	searchStartY = max(1,cellY -2);
	searchEndY = min(cellY+2,size(grid,1));
    searchStartZ = max(1,cellZ -2);
	searchEndZ = min(cellZ+2,size(grid,3));
	for x = searchStartX:searchEndX
		for y = searchStartY:searchEndY
			for z = searchStartZ:searchEndZ
				pointIndex = grid(x,y,z);
				if (pointIndex-1 != -1)
					sqrDst = sum((ceil(candidate(1,:)) - points(pointIndex,:)).^2);
					if (sqrDst < r*r)
                		return
					endif
            	endif
			endfor
		endfor
    endfor
    validPoint = true;
	return
  endif
endfunction