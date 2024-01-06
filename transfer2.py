from PIL import Image

def resize_and_convert_to_binary_data(input_path):
    # 打开图片
    original_image = Image.open(input_path)

    # 调整大小为 72x72
    resized_image = original_image.resize((78, 24))

    # 转换为黑白模式
    bw_image = resized_image.convert('L')

    # 通过设定阈值进行二值化并反转
    threshold = 70  # 阈值，根据需要调整
    binary_image = bw_image.point(lambda x: 1 if x > threshold else 0, '1')

    # 获取二值化后的像素数据
    binary_data = list(binary_image.getdata())

    return binary_data

def save_binary_data_to_file(binary_data, output_file_path):
    with open(output_file_path, 'w') as file:
        for i, value in enumerate(binary_data, 1):
            if i % 78 == 1:  # 在每行的首部加上 '72'b'
                file.write("78'b")
            file.write(str(value))
            if i % 78 == 0:  # 在每行的末尾加上逗号和换行符
                file.write(',\n')
            else:
                file.write(' ')

if __name__ == "__main__":
    input_image = input("file: ")
    # 输入文件路径
    input_image_path = input_image + ".png"  # 替换为你的实际输入文件路径

    # 获取二值数据
    binary_data = resize_and_convert_to_binary_data(input_image_path)

    # 输出文件路径
    output_file_path = f"{input_image}.txt"  # 替换为你的实际输出文件路径

    # 保存二值数据到文件
    save_binary_data_to_file(binary_data, output_file_path)
