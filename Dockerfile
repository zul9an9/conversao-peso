FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ConversaoPeso.Web/ConversaoPeso.Web.csproj", "ConversaoPeso.Web/"]
RUN dotnet restore "ConversaoPeso.Web/ConversaoPeso.Web.csproj"
COPY . .
WORKDIR "/src/ConversaoPeso.Web"
RUN dotnet build "ConversaoPeso.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConversaoPeso.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]

