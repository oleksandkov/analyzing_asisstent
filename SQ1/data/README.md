# Edmonton Cafes Dataset

This dataset contains information about cafes in the Edmonton area, including all existing brands and their individual shop locations.

## Data Files

### table1.csv (cafe_brands)

Brand-level summary data with location counts and historical opening data.

| Column              | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| Brand Name          | Name of the cafe brand                                                              |
| Type                | Category of the brand (Local Chain, Independent, Chain, Local Roaster, Bakery/Cafe) |
| Number of Locations | Total number of locations in Edmonton                                               |
| Population 2025     | Edmonton population in 2025                                                         |
| Mature Area         | Number of locations in the Mature Area sector                                       |
| North Sector        | Number of locations in the North Sector                                             |
| Northeast Sector    | Number of locations in the Northeast Sector                                         |
| Northwest Sector    | Number of locations in the Northwest Sector                                         |
| Southeast Sector    | Number of locations in the Southeast Sector                                         |
| Southwest Sector    | Number of locations in the Southwest Sector                                         |
| West Sector         | Number of locations in the West Sector                                              |
| 2025-2000           | Number of locations opened in each respective year                                  |

### table2.csv (cafe_locations)

Individual cafe location data with addresses.

| Column           | Description                                                     |
| ---------------- | --------------------------------------------------------------- |
| Brand Name       | Name of the cafe brand                                          |
| Building Num     | Building/street number                                          |
| Street Name      | Name of the street                                              |
| Quadrant         | City quadrant (NW, SW, etc.)                                    |
| Postal Code      | Canadian postal code                                            |
| Neighborhood     | Name of the neighborhood                                        |
| Sector           | City sector (Mature Area, North Sector, Southwest Sector, etc.) |
| Verified Address | Full verified address                                           |

## SQLite Database

The data is also available in SQLite format: `edmonton_cafes.sqlite`

- **cafe_brands** table: 61 rows (from table1.csv)
- **cafe_locations** table: 268 rows (from table2.csv)

Tables can be joined on `BrandName` to analyze individual locations alongside brand-level statistics.
