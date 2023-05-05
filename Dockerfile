FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY testdocker.csproj .
RUN dotnet restore testdocker.csproj
COPY . .
RUN dotnet build testdocker.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish testdocker.csproj -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf