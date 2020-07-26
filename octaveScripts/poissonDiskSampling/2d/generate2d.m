# Reference: Fast Poisson Disk Sampling in Arbitrary Dimensions
# Robert Bridson
# University of British Columbia
# *************************************************************

# clear workspace and close all figures
clear
close all

# Setup hyper-parameters
# **********************

# Controls distancing of sampled points
# ns = 19;r = 1.45; #for 19x19x19
# ns = 9;r=3.5; # generated for 9x9x9
ns = 5;r = 1.41; #for 19x19x19

# Number of dimensions
n = 2;

# the limit on number of samples to be chosen before rejecting a point
k = 10;

# width of a cell or cell size
w = r / sqrt(n);


# Size of original grid to be sampled
width = 10;
height = 10;

# STEP 0
# ******
# divide space of grid in to columns, rows and slices having size determined above
# calculate total columns, rows and slices with in this grid
cols = ceil(width / w);
rows = ceil(height / w);
# Initialize a grid of the size determined above,
# This will contain sampled points and help manage the distancing
backgroudGrid(1:rows,1:cols) = 0;

# STEP 1
# ******
# TODO MAYBE this can be more random
# discretize and strore the point
points(1,:) = ceil([width/2,height/2]);
sampledPoints = points(1,:); 
slack_x = ceil(points(1,1)/w);
slack_y = ceil(points(1,2)/w);
# Store index of the point in a Grid
backgroudGrid(slack_x,slack_y) = size(points,1);

# STEP 2
# ******
downSamplingSize = ns*ns;
indexOfGeneratedPoints = 0;
indexOfPointsGettingRemovedFromList = 0
while sum(sum(backgroudGrid!=0)) < downSamplingSize
  spawnIndex = randi([1,size(sampledPoints,1)]);
  spawnCenter = sampledPoints(spawnIndex,:);
  
  candidateAccepted = false;
  for i=1:k
    # Log
    indexOfGeneratedPoints = indexOfGeneratedPoints + 1;
    # see derivation if confused
    # generate a random unit vector in spherical coordinates
    phi = rand*2*pi;
    direction = [cos(phi),sin(phi)];
    # chose a candidate b/w r and 2r
    candidate = spawnCenter + direction*(rand+1)*r;
    if isValid(candidate,height,width,w,points,backgroudGrid,r)
      points(size(points,1)+1,:) = ceil(candidate(1,:));
      
      # TODO make slack var
      slack_x = ceil(candidate(1)/w);
      slack_y = ceil(candidate(2)/w);
      backgroudGrid(slack_x,slack_y)=size(points,1);
      
      sampleIndexes = backgroudGrid(backgroudGrid!=0);
      sampledPoints = points(sampleIndexes,:);
      
      candidateAccepted = true;
      # logs to see the progress
      lenPoints = size(points,1)
      lenSamples = size(sampledPoints,1)
      populationBackgroundGrid=sum(sum(backgroudGrid!=0))
      break;
    endif
  endfor
  if !candidateAccepted
    # Log
    indexOfPointsGettingRemovedFromList = indexOfPointsGettingRemovedFromList + 1;
    # TODO remove this point from list MAYBE
    # TODO remove this point from background grid DONE
    slack_x = ceil(spawnCenter(1)/w);
    slack_y = ceil(spawnCenter(2)/w);
    backgroudGrid(slack_x,slack_y)=0;
    # list of indexes in backgroudGrid
    sampleIndexes = backgroudGrid(backgroudGrid!=0);
    sampledPoints = points(sampleIndexes,:);
  endif
endwhile