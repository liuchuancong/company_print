import os
import tensorflow as tf
import numpy as np
from tqdm import tqdm  # 导入 tqdm 用于显示进度条
 
def download_mnist(save_dir):
    # 加载 MNIST 数据集
    mnist = tf.keras.datasets.mnist
 
    # 下载数据集
    (x_train, y_train), (x_test, y_test) = mnist.load_data()
 
    # 创建保存目录
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)
 
    # 保存训练集
    train_dir = os.path.join(save_dir, 'train')
    os.makedirs(train_dir, exist_ok=True)
    # 使用 tqdm 显示训练集下载进度
    for i, (image, label) in tqdm(enumerate(zip(x_train, y_train)), total=len(x_train), desc="Downloading training set"):
        # 将二维数组转换为三维数组，因为 save_img 函数期望输入是三维数组
        image = np.expand_dims(image, axis=-1)
        # 创建以标签命名的子文件夹
        label_dir = os.path.join(train_dir, str(label))
        os.makedirs(label_dir, exist_ok=True)
        # 保存图像到对应的子文件夹中
        image_path = os.path.join(label_dir, f"{i}.png")
        tf.keras.preprocessing.image.save_img(image_path, image)
 
    # 保存测试集
    test_dir = os.path.join(save_dir, 'test')
    os.makedirs(test_dir, exist_ok=True)
    # 使用 tqdm 显示测试集下载进度
    for i, (image, label) in tqdm(enumerate(zip(x_test, y_test)), total=len(x_test), desc="Downloading test set"):
        # 将二维数组转换为三维数组
        image = np.expand_dims(image, axis=-1)
        # 创建以标签命名的子文件夹
        label_dir = os.path.join(test_dir, str(label))
        os.makedirs(label_dir, exist_ok=True)
        # 保存图像到对应的子文件夹中
        image_path = os.path.join(label_dir, f"{i}.png")
        tf.keras.preprocessing.image.save_img(image_path, image)
 
    return len(x_train), len(x_test)
 
if __name__ == "__main__":
    save_dir = "mnist_dataset"
    train_samples, test_samples = download_mnist(save_dir)
 
    print("MNIST 数据集下载完成！")
    print("训练集样本数量:", train_samples)
    print("测试集样本数量:", test_samples)
    print("数据集保存在:", save_dir)