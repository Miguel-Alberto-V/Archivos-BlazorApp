# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

WORKDIR /app

# Crea un nuevo proyecto Blazor
RUN dotnet new blazor -o BlazorApp

# Copiar las paginas modificadas
COPY Counter.razor BlazorApp/Components/Pages/Counter.razor
COPY Home.razor BlazorApp/Components/Pages/Home.razor
COPY NavMenu.razor BlazorApp/Layout/NavMenu.razor
COPY Todo.razor BlazorApp/Components/Pages/
COPY TodoItem.cs BlazorApp/

WORKDIR /app/BlazorApp

# Restaura, compila y publica en un solo paso para optimizar capas
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: Imagen de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
