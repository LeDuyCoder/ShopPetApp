@echo off
REM Khởi động các dịch vụ với docker-compose
docker-compose up -d

REM Thêm thời gian chờ để đảm bảo container đã được khởi động hoàn toàn
timeout /t 2 /nobreak

REM Kiểm tra tất cả các container đang chạy để xác nhận tên và ID
docker ps

REM Lấy ID của container postgres-db sau khi khởi động
for /f "tokens=1" %%i in ('docker ps --filter "name=postgres-db" --format "{{.ID}}"') do set container_id=%%i

REM Kiểm tra xem container_id có tồn tại không
if "%container_id%"=="" (
    echo Could not find container with name postgres-db
    pause
    exit /b 1
)

REM Sao chép file backup vào container
docker cp .\backup.tar %container_id%:/backup.tar

REM Restore database từ file backup
docker exec -i %container_id% pg_restore -U postgres -d shopPetDB /backup.tar

pause
