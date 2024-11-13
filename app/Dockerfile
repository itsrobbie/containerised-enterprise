# Use .NET 8 SDK to build the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["LdapApp/LdapApp.csproj", "LdapApp/"]
RUN dotnet restore "LdapApp/LdapApp.csproj"
COPY . .
WORKDIR "/src/LdapApp"
RUN dotnet build "LdapApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "LdapApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "LdapApp.dll"]
