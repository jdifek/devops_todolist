# Указание базового образа Python
ARG PYTHON_BASE_VERSION=3.10
FROM python:${PYTHON_BASE_VERSION} AS build

# Установить рабочую директорию
WORKDIR /app

# Скопировать зависимости в контейнер
COPY requirements.txt /app/

# Установить зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копирование .env файла
COPY .env /app/

# Копирование остальных файлов проекта
COPY . /app/

# Миграция базы данных
RUN python manage.py migrate

# Финальная стадия
FROM python:${PYTHON_BASE_VERSION}
WORKDIR /app

# Копировать приложение из build stage
COPY --from=build /app /app

# Установить зависимости в финальном образе
RUN pip install --no-cache-dir -r requirements.txt

# Установить переменную окружения для логов
ENV PYTHONUNBUFFERED=1

# Запуск сервера
CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
