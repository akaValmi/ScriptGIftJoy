-- Tabla para los tipos de usuarios
CREATE TABLE TiposUsuarios (
    TipoUsuarioID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO


-- Tabla para los usuarios
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY,
    TipoUsuarioID INT NOT NULL,
    Primer_Nombre NVARCHAR(100) NOT NULL,
    Segundo_Nombre NVARCHAR(100),
    Primer_Apellido NVARCHAR(100) NOT NULL,
    Segundo_Apellido NVARCHAR(100),
    Correo NVARCHAR(100) NOT NULL UNIQUE,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
	active BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (TipoUsuarioID) REFERENCES TiposUsuarios(TipoUsuarioID)
);
GO

-- Tabla para los departamentos
CREATE TABLE Departamentos (
    DepartamentoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL
);
GO

-- Tabla para las ciudades
CREATE TABLE Ciudades (
    CiudadID INT PRIMARY KEY IDENTITY,
    DepartamentoID INT,
    Nombre NVARCHAR(100) NOT NULL,
    FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID)
);
GO

-- Tabla para las direcciones
CREATE TABLE Direcciones (
    DireccionID INT PRIMARY KEY IDENTITY,
    UsuarioID INT NOT NULL,
    CiudadID INT NOT NULL,
    Direccion NVARCHAR(255) NOT NULL,
    Telefono NVARCHAR(20),  -- Nueva columna para el teléfono
    FOREIGN KEY (CiudadID) REFERENCES Ciudades(CiudadID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);
GO


-- Tabla para los proveedores
CREATE TABLE Proveedores (
    ProveedorID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Contacto NVARCHAR(100),
    Telefono NVARCHAR(15),
    Correo NVARCHAR(100)
);
GO


-- Tabla para los colores
CREATE TABLE Colores (
    ColorID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Tabla para las marcas
CREATE TABLE Marcas (
    MarcaID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL UNIQUE,
	Hexadecimal NVARCHAR(100) NOT NULL
);
GO
-- Tabla para los tipos de tallas
CREATE TABLE Tallas (
    TallaID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Tabla para los productos
CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Stock INT NOT NULL,
	Img TEXT NOT NULL,
    MarcaID INT,
    FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID)
);
GO


-- Tabla de relación entre productos y tallas
CREATE TABLE ProductoTallas (
    ProductoID INT NOT NULL,
    TallaID INT NOT NULL,
    PRIMARY KEY (ProductoID, TallaID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (TallaID) REFERENCES Tallas(TallaID)
);
GO

-- Tabla intermedia para la relación de muchos a muchos entre Productos y Colores
CREATE TABLE ProductoColores (
    ProductoID INT NOT NULL,
    ColorID INT NOT NULL,
	Img TEXT,
    PRIMARY KEY (ProductoID, ColorID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (ColorID) REFERENCES Colores(ColorID)
);
GO

-- Tabla para las categorías de productos
CREATE TABLE Categorias (
    CategoriaID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255)
);
GO

-- Tabla para la relación entre productos y categorías
CREATE TABLE ProductosCategorias (
    ProductoID INT NOT NULL,
    CategoriaID INT NOT NULL,
    PRIMARY KEY (ProductoID, CategoriaID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID)
);
GO

-- Tabla para los estados de las facturas
CREATE TABLE EstadosFacturas (
    EstadoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO


-- Tabla para los métodos de pago
CREATE TABLE TiposPago (
    TipoPagoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO


-- Tabla para los bundles
CREATE TABLE Bundles (
    BundleID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
	CostoPreparacion DECIMAL(18, 2);
);
GO


-- Tabla intermedia para la relación de muchos a muchos entre Bundles y Colores
CREATE TABLE BundleColores (
    BundleID INT NOT NULL,
    ColorID INT NOT NULL,
    Img TEXT, -- Opcional: Imagen asociada a la combinación bundle-color
    PRIMARY KEY (BundleID, ColorID),
    FOREIGN KEY (BundleID) REFERENCES Bundles(BundleID),
    FOREIGN KEY (ColorID) REFERENCES Colores(ColorID)
);
GO



-- Tabla para los detalles de los bundles
CREATE TABLE BundleDetalles (
    BundleDetalleID INT PRIMARY KEY IDENTITY,
    BundleID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    FOREIGN KEY (BundleID) REFERENCES Bundles(BundleID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);
GO

-- Tabla para los inventarios
CREATE TABLE Inventarios (
    InventarioID INT PRIMARY KEY IDENTITY,
    ProductoID INT NOT NULL,
	ProveedorID INT,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    FechaIngreso DATETIME NOT NULL DEFAULT GETDATE(),
    FechaExpiracion DATETIME,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID)
);
GO

-- Tabla para las facturas
CREATE TABLE Facturas (
    FacturaID INT PRIMARY KEY IDENTITY,
    UsuarioID INT NOT NULL,
    FechaPedido DATETIME NOT NULL DEFAULT GETDATE(),
    EstadoID INT NOT NULL,
    TipoPagoID INT NOT NULL,
    DireccionID INT NOT NULL,
    Descuento DECIMAL(10, 2) DEFAULT 0.00,
    Total DECIMAL(10, 2) NOT NULL,
    Impuestos DECIMAL(10, 2) NOT NULL,
    RTN NVARCHAR(20) NOT NULL,
	Observaciones TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (EstadoID) REFERENCES EstadosFacturas(EstadoID),
    FOREIGN KEY (TipoPagoID) REFERENCES TiposPago(TipoPagoID),
    FOREIGN KEY (DireccionID) REFERENCES Direcciones(DireccionID)
);
GO

-- Tabla para los tipos de items (productos y bundles)
CREATE TABLE ItemTypes (
    ItemTypeID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE
);
GO

-- Tabla para los detalles de las facturas
CREATE TABLE DetallesFacturas (
    DetalleID INT PRIMARY KEY IDENTITY,
    FacturaID INT NOT NULL,
    ItemID INT NOT NULL,
    ItemTypeID INT NOT NULL,
	ColorID INT,
	TallaID INT,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (FacturaID) REFERENCES Facturas(FacturaID),
    FOREIGN KEY (ItemTypeID) REFERENCES ItemTypes(ItemTypeID),
	FOREIGN KEY (ColorID) REFERENCES Colores(ColorID),
	FOREIGN KEY (TallaID) REFERENCES Tallas(TallaID),
    CHECK (ItemTypeID IN (1, 2))
);
GO
