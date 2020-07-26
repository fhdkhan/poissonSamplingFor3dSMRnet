# julia 1.1.0
function ComplexToRGB(A)
  lengthx,lengthy,lengthz,lengthf = size(A);
    ##### Color Phase
    angleDeg = 360; maxHueInHSV = 360
    cm = linspace_(ColorTypes.HSV(0,1,1),ColorTypes.HSV(maxHueInHSV,1,1),angleDeg);
    cr=zeros(angleDeg);
    cg=zeros(angleDeg);
    cb=zeros(angleDeg);

    for i=1:angleDeg
      cr[i]=convert(RGB{Float64},cm[i]).r
      cg[i]=convert(RGB{Float64},cm[i]).g
      cb[i]=convert(RGB{Float64},cm[i]).b
    end

    knots=(linspace_(0,2*pi,angleDeg),);
    itpr = interpolate(knots,cr, Gridded(Linear()));
    itpg = interpolate(knots,cg, Gridded(Linear()));
    itpb = interpolate(knots,cb, Gridded(Linear()));

    # convert complex values to absolute value and phase into Color
    dataAbs = abs.(A);
    dataReal = real.(A);
    dataImag = imag.(A);

    minReal,maxReal = extrema(dataReal);
    minImag,maxImag = extrema(dataImag);

    dataAngle = angle.(A);
    dataAngle[dataAngle.<0]=dataAngle[dataAngle.<0].+2*pi; # why shift negative by 2pi, instead of everything by pi?

    dataC = zeros(Float64,lengthx,lengthy,lengthz, 3, lengthf);
    dataC[:,:,:,1,:]=dataAbs.*reshape(itpr.(dataAngle), lengthx, lengthy, lengthz, lengthf);
    dataC[:,:,:,2,:]=dataAbs.*reshape(itpg.(dataAngle), lengthx, lengthy, lengthz, lengthf);
    dataC[:,:,:,3,:]=dataAbs.*reshape(itpb.(dataAngle), lengthx, lengthy, lengthz, lengthf);

    minAbs,maxAbs = extrema(dataC);
   return dataC,minAbs,maxAbs
end


function RGBToComplex(dataRGB)
    lengthx,lengthy,lengthz,lengthc,lengthf = size(dataRGB);
    dataComplex = zeros(Complex{Float32},lengthx,lengthy,lengthz,lengthf)

    for k=1:lengthx
        for l=1:lengthy
            for m=1:lengthz
                for n=1:lengthf
                    rgb = ColorTypes.RGB(dataRGB[k,l,m,1,n],dataRGB[k,l,m,2,n],dataRGB[k,l,m,3,n])
                    hsv = convert(HSV,rgb);
                    dataComplex[k,l,m,n] = rectangularForm(hsv.v,hsv.h /360*2*pi)
                end
            end
        end
    end
    return dataComplex
end

function rectangularForm(absolueValue, angle)
    return absolueValue*cos(angle) + absolueValue*sin(angle)*im
end
