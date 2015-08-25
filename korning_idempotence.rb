# Use this file to import the sales information into the
# the database.
require "csv"
require "pg"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

def split_header(string)
  string = string.chomp(")")
  string_array = string.split(" (")
  return string_array
end


def unique_customer?(name)
  result = db_connection do |conn|
    conn.exec("SELECT * FROM customers WHERE customer_name = $1", [name])
  end
  result.to_a.empty?
  # returns true if customer_name is unique, use in an if statement to create new
end

# THIS WORKS. POPULATES CUSTOMERS DEPENDS ON UNIQUE EMPLOYEE METHOD
db_connection do |conn|
  CSV.foreach('sales.csv', headers: true, header_converters: :symbol) do |row|
    customer = split_header(row[:customer_and_account_no])
    if unique_customer?(customer[0])
      conn.exec("INSERT INTO customers (customer_name, account_no) VALUES ($1, $2)", [customer[0], customer[1]])
    end
  end
end


# THIS WORKS. FOR CHECKING UNIQUE EMPLOYEES
def unique_employee?(name)
  result = db_connection do |conn|
    conn.exec("SELECT * FROM employees WHERE employee_name = $1", [name])
  end
  result.to_a.empty?
  # returns true if employee_name is unique, use in an if statement to create new
end

# THIS WORKS. POPULATES EMPLOYEES DEPENDS ON UNIQUE EMPLOYEE METHOD
db_connection do |conn|
  table_rows = conn.exec("SELECT COUNT(*) FROM employees")
  table_rows = table_rows.first["count"]
  if table_rows == 0
    CSV.foreach('sales.csv', headers: true, header_converters: :symbol) do |row|
      employee = split_header(row[:employee])
      if unique_employee?(employee[0])
        conn.exec("INSERT INTO employees (employee_name, employee_email) VALUES ($1, $2)", [employee[0], employee[1]])
      end
    end
  else
    #does not populate table
  end
end


db_connection do |conn|
  CSV.foreach('sales.csv', headers: true, header_converters: :symbol) do |row|

    #Find customer_id
    customer_name = split_header(row[:customer_and_account_no])[0]
    customer_id = conn.exec("SELECT id FROM customers WHERE customer_name = $1", [customer_name])
    customer_id = customer_id.first['id']

    #Find employee_id
    employee_name = split_header(row[:employee])[0]
    employee_id = conn.exec("SELECT id FROM employees WHERE employee_name = $1", [employee_name])
    employee_id = employee_id.first['id']

    conn.exec("INSERT INTO sales (
    invoice_no,
    sale_date,
    product_name,
    units_sold,
    sale_amount,
    invoice_frequency,
    customer_id,
    employee_id)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", [
      row[:invoice_no],
      row[:sale_date],
      row[:product_name],
      row[:units_sold],
      row[:sale_amount],
      row[:invoice_frequency],
      customer_id,
      employee_id
    ])
  end
end
