# 使用最精简的 Python 镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装时区数据包
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖列表和执行文件到容器中
COPY requirements.txt .
COPY ClashForge.py .
COPY upload_gist.py .

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt \
    && rm -f requirements.txt \
    mkdir input

# 暴露 5354 端口
EXPOSE 5354

# 启动脚本
CMD ["sh", "-c", "python ClashForge.py && python upload_gist.py"]
