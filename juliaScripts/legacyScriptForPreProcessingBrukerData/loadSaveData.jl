# julia 1.1.0
using MPILib,HDF5,Interpolations,ColorTypes
include("RGBToComplex.jl")

function prepareSuperresolution(datadir::String, particleType::String)
    bSF = MPIFile(datadir);
    SNRThresh = 3
    minFreq = 80e3
    f = filterFrequencies(bSF,minFreq=minFreq,SNRThresh=SNRThresh);
    A, grid = getSF(bSF,f,returnasmatrix=false);
    lengthx,lengthy,lengthz,lengthf = size(A);

    ##### Convert Cmplex to RGB
    dataC, minAbs, maxAbs = ComplexToRGB(A)

    #Frequencies in Hz
    TR=lcm(102,96,99)/(2.5*10.0^6);
    Δf=1/TR;
    f_Hz = (f.-1).*Δf;

    filename="Data$(lengthx)x$(lengthy)x$(lengthz)x3x$(lengthf)$particleType.h5";
    h5write(filename,"/Data",dataC)
    h5write(filename,"/minAbs",minAbs);
    h5write(filename,"/maxAbs",maxAbs);
    h5write(filename,"/datadir",datadir);
    h5write(filename,"/SNRThresh",SNRThresh);
    h5write(filename,"/minFreq",minFreq);
    h5write(filename,"/f",f);
    h5write(filename,"/f_Hz",f_Hz);

    return dataC, f
end

datadir = "/opt/mpidata/20180228_180048_OpenMPIData_1_1/9"
dataPerimag,fPerimag = prepareSuperresolution(datadir,"Perimag");
# datadir = "/opt/mpidata/20180228_180048_OpenMPIData_1_1/19"
# dataSynomagPEG,fSynomagPEG = prepareSuperresolution(datadir,"SynomagPEG");
# datadir = "/opt/mpidata/20180228_180048_OpenMPIData_1_1/22"
# dataZahnzementPerimag,fZahnzementPerimag = prepareSuperresolution(datadir,"ZahnzementPerimag");


#MPIFiles.saveasMDF(...)
