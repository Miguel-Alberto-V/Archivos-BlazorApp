# BlazorApp

Este proyecto es una aplicación Blazor que se puede construir y ejecutar utilizando Docker. A continuación, se detallan los pasos para implementar y usar los archivos en este proyecto.

## Estructura del Proyecto

.gitignore Counter.razor Dockerfile Home.razor NavMenu.razor script.sh Todo.razor TodoItem.cs


## Archivos y su Funcionalidad

### `Counter.razor`

Este archivo define una página de contador en la aplicación Blazor.

```razor
@page "/counter"
@rendermode InteractiveServer
<PageTitle>Counter</PageTitle>
<h1>Counter</h1>
<p role="status">Current count: @currentCount</p>
<button class="btn btn-primary" @onclick="IncrementCount">Click me</button>
@code {
    private int currentCount = 0;
    [Parameter]
    public int IncrementAmount { get; set; } = 1;
    private void IncrementCount()
    {
        currentCount += IncrementAmount;
    }
}
```
### `Home.razor`
Este archivo define la página principal de la aplicación Blazor.
```razor
@page "/"
<PageTitle>Home</PageTitle>
<h1>Hello, world!</h1>
Welcome to your new app.
<Counter IncrementAmount="10" />
```
### `NavMenu.razor`

Este archivo define el menú de navegación de la aplicación Blazor.
```razor
<div class="top-row ps-3 navbar navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="">BlazorApp</a>
    </div>
</div>
<input type="checkbox" title="Navigation menu" class="navbar-toggler" />
<div class="nav-scrollable" onclick="document.querySelector('.navbar-toggler').click()">
    <nav class="flex-column">
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="" Match="NavLinkMatch.All">
                <span class="bi bi-house-door-fill-nav-menu" aria-hidden="true"></span> Home
            </NavLink>
        </div>
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="counter">
                <span class="bi bi-plus-square-fill-nav-menu" aria-hidden="true"></span> Counter
            </NavLink>
        </div>
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="weather">
                <span class="bi bi-list-nested-nav-menu" aria-hidden="true"></span> Weather
            </NavLink>
        </div>
        <div class="nav-item px-3">
            <NavLink class="nav-link" href="todo">
                <span class="bi bi-list-nested-nav-menu" aria-hidden="true"></span> Todo
            </NavLink>
        </div> 
    </nav>
</div>
```
### `Todo.razor`

Este archivo define una página de tareas pendientes en la aplicación Blazor.
```razor
@page "/todo"
@rendermode InteractiveServer

<h3>Todo (@todos.Count(todo => !todo.IsDone))</h3>

<ul>
    @foreach (var todo in todos)
    {
        <li>
            <input type="checkbox" @bind="todo.IsDone" />
            <input @bind="todo.Title" />
        </li>
    }
</ul> 

<input @bind="newTodo" />
<button @onclick="AddTodo">Add todo</button>

@code {
    private List<TodoItem> todos = new();
    string newTodo = "";

    void AddTodo()
    {
        if (!string.IsNullOrWhiteSpace(newTodo))
        {
            todos.Add(new TodoItem { Title = newTodo });
            newTodo = string.Empty;
        }
    }
}
```
### `TodoItem.cs`
```cs
Este archivo define la clase TodoItem utilizada en la página de tareas pendientes.

public class TodoItem
{
    public string? Title { get; set; }
    public bool IsDone { get; set; } = false;
}
```

### `Dockerfile`

```Dockerfile
Este archivo define el proceso de construcción y ejecución de la aplicación Blazor utilizando Docker.

# Etapa 1: Construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app
# Crea un nuevo proyecto Blazor
RUN dotnet new blazor -o BlazorApp
# Copiar las paginas modificadas
COPY Counter.razor BlazorApp/Components/Pages/Counter.razor
COPY Home.razor BlazorApp/Components/Pages/Home.razor
COPY NavMenu.razor BlazorApp/Components/Layout/NavMenu.razor
COPY Todo.razor BlazorApp/Components/Pages/
COPY TodoItem.cs BlazorApp/
WORKDIR /app/BlazorApp
# Restaura, compila y publica en un solo paso para optimizar capas
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: Imagen de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/publish .
# Establece la URL en la que la aplicación escuchará
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
ENTRYPOINT ["dotnet", "BlazorApp.dll"]
```

## script.sh
Este archivo de script automatiza el proceso de clonación del repositorio, construcción de la imagen Docker y ejecución del contenedor Docker.
```sh
#!/bin/bash
# Definir URLs de los repositorios
ARCHIVOS_BLAZOR="https://github.com/Miguel-Alberto-V/Archivos-BlazorApp"
# Clonar el repositorio
git clone $ARCHIVOS_BLAZOR Archivos-BlazorApp
# Crear el directorio de la aplicación Blazor
mkdir -p Archivos-BlazorApp/BlazorApp
# Copiar las páginas modificadas y otros archivos necesarios
cp Archivos-BlazorApp/Counter.razor Archivos-BlazorApp/BlazorApp/Components/Pages/Counter.razor
cp Archivos-BlazorApp/Home.razor Archivos-BlazorApp/BlazorApp/Components/Pages/Home.razor
cp Archivos-BlazorApp/NavMenu.razor Archivos-BlazorApp/BlazorApp/Components/Layout/NavMenu.razor
cp Archivos-BlazorApp/Todo.razor Archivos-BlazorApp/BlazorApp/Components/Pages/
cp Archivos-BlazorApp/TodoItem.cs Archivos-BlazorApp/BlazorApp/
# Navegar al directorio donde se encuentra el Dockerfile
cd Archivos-BlazorApp
# Construir la imagen Docker utilizando el Dockerfile
docker build -t my-blazor-app .
# Ejecutar el contenedor Docker
docker run -d -p 5000:5000 my-blazor-app
# Limpiar los repositorios clonados
cd ..
rm -rf Archivos-BlazorApp
# Mostrar mensaje indicando que la aplicación está corriendo
echo "La aplicación está corriendo en http://localhost:5000"
```
## Cómo Ejecutar el Proyecto
1. Clona el repositorio y navega al directorio del proyecto.
2. Ejecuta el script script.sh para construir y ejecutar la aplicación en un contenedor Docker.
```./script.sh ```
3. La aplicación estará disponible en http://localhost:5000.

¡Disfruta desarrollando con Blazor y Docker!
