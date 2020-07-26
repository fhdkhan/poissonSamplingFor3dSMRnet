import numpy as np
import h5py
import os
import pandas as pd

def load_poissondisc_sampling(path):
    points = np.loadtxt(path, delimiter=',')
    return points


def zero_padding(dataset, out_shape):
    # zero padding
    input_size = tuple(dataset.shape[2:])
    pad_size = [(0, 0), (0, 0), 0, 0, 0]
    for vI, vO, i in zip(input_size, out_shape, range(2, 6)):
        diff = (vO - vI)
        if diff % 2 != 0:
            pad_size[i] = (2 * (diff // 2), diff % 2)
        else:
            pad = (diff // 2)
            pad_size[i] = (pad, pad)

    return np.pad(dataset, tuple(pad_size), mode='constant', constant_values=0)


def load_dataset(file_path, data_format):
    with h5py.File(file_path, 'r') as hf:
        dset_rgb = None
        if data_format == 'ImagReal':
            dset_imag = np.array(hf['DataImag']).astype(np.float32)[:, np.newaxis, :, :, :]
            print(np.mean(dset_imag))
            print(np.std(dset_imag))
            dset_real = np.array(hf['DataReal']).astype(np.float32)[:, np.newaxis, :, :, :]
            print(np.mean(dset_real))
            print(np.std(dset_real))
            dset_rgb = np.concatenate((dset_imag, dset_real), axis=1)
        elif data_format == 'RGB':
            dset_rgb = np.array(hf['Data']).astype(np.float32)
            print(np.mean(dset_rgb))
            print(np.std(dset_rgb))
        for key in hf.keys():
            print(key)  # Names of the groups in HDF5 file.
            if 'hz' in key.lower():
                dset_hz = np.array(hf[key]).astype(np.float32)

    return dset_rgb, dset_hz


def transform_to_BGR_FHWDC(dataset, data_format='RGB'):
    # RGB -> BGR; # F CHWD -> F HWDC
    if data_format == 'RGB':
        return np.transpose(dataset[:, [2, 1, 0], :, :, :], [0, 2, 3, 4, 1])
    return np.transpose(dataset, [0, 2, 3, 4, 1])


def transform_to_RGB_FCHWD(dataset, data_format='RGB'):
    # BGR -> RGB; # F HWDC -> F CHWD
    if data_format == 'RGB':
        return np.transpose(dataset[:, :, :, :, [2, 1, 0]], [0, 4, 1, 2, 3])
    return np.transpose(dataset, [0, 4, 1, 2, 3])


def save_dataset(dataset, dataset_hz, file_path):
    print('Saving dataset to ', file_path)
    with h5py.File(file_path, 'w') as hf:
        hf.create_dataset("data", data=dataset)
        hf.create_dataset("hz", data=dataset_hz)


def mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)


def main():
    poissonDiskSampleDF2x = pd.read_csv("/hdd/fhd/MPISystemMatrix/grids/ok/sampledPoints_2x.csv", header=None)
    poissonDiskSample2x = poissonDiskSampleDF2x.to_numpy()
    poissonDiskSampleDF4x = pd.read_csv("/hdd/fhd/MPISystemMatrix/grids/ok/sampledPoints_4x.csv", header=None)
    poissonDiskSample4x = poissonDiskSampleDF4x.to_numpy()

    file_names = ['Data37x37x37x3x3175Perimag_SNR3.h5']
    file_names += ['Data37x37x37x3x3929SynomagPEG_SNR3.h5']
    file_name_outs = ["Perimag"]
    file_name_outs += ["SynomagPEG"]
    data_format = 'ImagReal'  # ImagReal | RGB
    data_root = '/hdd/fhd/MPISystemMatrix'
    zeroPad_to = (40, 40, 40)
    equi_sampling = [4, 2]

    for file_name, file_name_out in zip(file_names, file_name_outs):
        file_path = os.path.join(data_root, file_name)
        file_path_out = os.path.join(data_root, 'pre_processed')
        mkdir(file_path_out)
        print('Loading dataset: {}'.format(file_path))
        dset_rgb, dset_hz = load_dataset(file_path, data_format)
        print(dset_rgb.shape)
        print('done')

        # tensor size need to be changed when imagReal 2 -> RGB 3
        if data_format == 'RGB':
            dset_rgb_poissonSampled4x = np.ndarray(shape=(dset_rgb.shape[0],3,9,9,9))
            dset_rgb_poissonSampled2x = np.ndarray(shape=(dset_rgb.shape[0],3,19,19,19))
        elif data_format == 'ImagReal':
            dset_rgb_poissonSampled4x = np.ndarray(shape=(dset_rgb.shape[0],2,9,9,9))
            dset_rgb_poissonSampled2x = np.ndarray(shape=(dset_rgb.shape[0],2,19,19,19))

        index = 0
        for i in range(9):
            for j in range(9):
                for k in range(9):
                    x = poissonDiskSample4x[index, 0]
                    y = poissonDiskSample4x[index, 1]
                    z = poissonDiskSample4x[index, 2]
                    index = index+1
                    dset_rgb_poissonSampled4x[:, :, i, j, k] = dset_rgb[:, :,  x - 1, y - 1, z - 1]

        print(dset_rgb_poissonSampled4x.shape)
        print("mean and std")
        print(np.mean(dset_rgb_poissonSampled4x))
        print(np.std(dset_rgb_poissonSampled4x))
        zeroPad_to_poisson4x = (10, 10, 10)
        print('Zero pad to {}'.format(zeroPad_to_poisson4x))
        dset_rgb_poissonSampled_zeroPad4x = zero_padding(dset_rgb_poissonSampled4x, zeroPad_to_poisson4x)
        print(dset_rgb_poissonSampled_zeroPad4x.shape)
        print('done')

        index = 0
        for i in range(19):
            for j in range(19):
                for k in range(19):
                    x = poissonDiskSample2x[index, 0]
                    y = poissonDiskSample2x[index, 1]
                    z = poissonDiskSample2x[index, 2]
                    index = index+1
                    dset_rgb_poissonSampled2x[:, :, i, j, k] = dset_rgb[:, :,  x - 1, y - 1, z - 1]

        print(dset_rgb_poissonSampled2x.shape)
        print("mean and std")
        print(np.mean(dset_rgb_poissonSampled2x))
        print(np.std(dset_rgb_poissonSampled2x))
        zeroPad_to_poisson2x = (20, 20, 20)
        print('Zero pad to {}'.format(zeroPad_to_poisson2x))
        dset_rgb_poissonSampled_zeroPad2x = zero_padding(dset_rgb_poissonSampled2x, zeroPad_to_poisson2x)
        print(dset_rgb_poissonSampled_zeroPad2x.shape)
        print('done')

        print('Zero pad HR dataset to {}'.format(zeroPad_to))
        dset_rgb_zeroPad = zero_padding(dset_rgb, zeroPad_to)
        print('done')

        np.random.seed(0)
        idxs = np.arange(len(dset_rgb))
        np.random.shuffle(idxs)
        t_size = int(len(dset_rgb) * 0.9) # split into 90% training and 10% validation

        phase_indxs = [idxs[:t_size], idxs[t_size:]]
        # Test ist the full dataset
        for i, phase in enumerate(['Train', 'Val']):
            out_freq = transform_to_BGR_FHWDC(dset_rgb_poissonSampled_zeroPad2x[phase_indxs[i]][:, :, :, :, :], data_format)
            shape_str = str(out_freq.shape).replace(", ", "x").replace("(", "").replace(")", "")
            file_path = file_path_out + '//{0}_{1}_SNR3_PoissonDisk_{2}_{3}.h5'.format(file_name_out, phase,  shape_str, data_format)
            save_dataset(out_freq, dset_hz[phase_indxs[i]], file_path)
            
            out_freq = transform_to_BGR_FHWDC(dset_rgb_poissonSampled_zeroPad4x[phase_indxs[i]][:, :, :, :, :], data_format)
            shape_str = str(out_freq.shape).replace(", ", "x").replace("(", "").replace(")", "")
            file_path = file_path_out + '//{0}_{1}_SNR3_PoissonDisk_{2}_{3}.h5'.format(file_name_out, phase,  shape_str, data_format)
            save_dataset(out_freq, dset_hz[phase_indxs[i]], file_path)


        for i, phase in enumerate(['Train', 'Val']):
            out_freq = transform_to_BGR_FHWDC(dset_rgb_zeroPad[phase_indxs[i]], data_format)
            shape_str = str(out_freq.shape).replace(", ", "x").replace("(", "").replace(")", "")
            file_path = file_path_out + '//{}_GT_SNR3_HR_{}_{}.h5'.format(file_name_out, shape_str, data_format)
            save_dataset(out_freq, dset_hz[phase_indxs[i]], file_path)

            for equi in equi_sampling:
                out_freq = transform_to_BGR_FHWDC(dset_rgb_zeroPad[phase_indxs[i]][:, :, ::equi, ::equi, ::equi], data_format)
                shape_str = str(out_freq.shape).replace(", ", "x").replace("(", "").replace(")", "")
                file_path = file_path_out + '//{0}_{1}_SNR3_Equi{2}x_{3}_{4}.h5'.format(file_name_out, phase, equi, shape_str, data_format)
                save_dataset(out_freq, dset_hz[phase_indxs[i]], file_path)

if __name__ == "__main__":
    main()
