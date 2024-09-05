# Sử dụng OpenJDK 17 làm hình ảnh cơ sở
FROM openjdk:17-jdk-alpine

# Đặt thư mục làm việc
WORKDIR /app

# Sao chép file JAR vào thư mục làm việc
COPY build/libs/shoppet-0.0.1-SNAPSHOT.jar /app/shoppet-0.0.1-SNAPSHOT.jar

# Chạy ứng dụng
ENTRYPOINT ["java", "-jar", "/app/shoppet-0.0.1-SNAPSHOT.jar"]