using com.logajog as logajog from '../db/schema';
using com.training as training from '../db/training';

define service CatalogService {
   entity Products          as
      select from logajog.reports.Products{
         ID,
         Name           as ProductName      @mandatory,
         Description                        @mandatory,
         ImageUrl,
         ReleaseDate,
         DiscontinuedDate,
         Price                              @mandatory,
         Height,
         Width,
         Depth,
         Quantity                           @(
            mandatory,
            assert.range: [
               0.00,
               20.00
            ]
         ),
         UnitOfMeasures as ToUnitOfMeasures @mandatory,
         Currency       as ToCurrency       @mandatory,
         Currency.ID    as CurrencyId,
         Category       as ToCategory       @mandatory,
         Category.ID    as CategoryId,
         Category.Name  as Category         @readonly,
         DimensionUnit  as ToDimensionUnit,
         SalesData,
         Supplier,
         Reviews,
         Rating,
         StockAvailability,
         ToStockAvailability
      };

   entity Supplier          as
      select from logajog.sales.Suppliers {
         ID,
         Name,
         Email,
         Phone,
         Fax,
         Product as ToProduct
      };

   @readonly
   entity Reviews           as
      select from logajog.materials.ProductReview {
         ID,
         Name,
         Rating,
         Comment,
         createdAt,
         Product as ToProduct
      };

   @readonly
   entity SalesData         as
      select from logajog.sales.SalesData {
         ID,
         DeliveryDate,
         Revenue,
         Currency.ID               as CurrencyKey,
         DeliveryMonth.ID          as DeliveryMonthId,
         DeliveryMonth.Description as DeliveryMonth,
         Product                   as ToProduct
      };

   @readonly
   entity StockAvailability as
      select from logajog.materials.StockAvailability {
         ID,
         Description,
         Product as ToProduct
      };

   @readonly
   entity VH_Categories     as
      select from logajog.materials.Categories {
         ID   as Code,
         Name as Text
      };

   @readonly
   entity VH_Currencies     as
      select from logajog.materials.Currencies {
         ID          as Code,
         Description as Text
      };

   @readonly
   entity VH_UnitOfMeasures as
      select from logajog.materials.UnitOfMeasures {
         ID          as Code,
         Description as Text
      };

   @readonly
   entity VH_DimensionUnits as
      select
         ID          as Code,
         Description as Text
      from logajog.materials.DimensionUnits;
}

define service MyService {
   entity SuppliersProduct  as
      select from logajog.materials.Products[Name = 'Milk']{
         *,
         Name,
         Description,
         Supplier.Address
      }
      where
         Supplier.Address.PostalCode = 98074;

   entity SupplierToSales   as
      select
         Supplier.Email,
         Category.Name,
         SalesData.Currency.ID,
         SalesData.Currency.Description
      from logajog.materials.Products;

   entity EntityInfix       as
      select Supplier[Name = 'Exotic Liquids'].Phone from logajog.materials.Products
      where
         Products.Name = 'Milk';

   entity EntityJoin        as
      select Phone from logajog.materials.Products
      left join logajog.sales.Suppliers as supp
         on(
            supp.ID = Products.Supplier.ID
         )
         and supp.Name = 'Exotic Liquids'
      where
         Products.Name = 'Milk';

}

define service Reports {
   entity AverageRating     as projection on logajog.reports.AverageRating;

   entity EntityCasting     as
      select
         cast(
            Price as       Integer
         )     as Price,
         Price as Price2 : Integer
      from logajog.materials.Products;

   entity EntityExists      as
      select from logajog.materials.Products {
         Name
      }
      where
         exists Supplier[Name = 'Exotic Liquids'];
}
