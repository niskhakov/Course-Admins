#!/bin/python
import psycopg2 as pg
import csv

class ShopDataClass:

    def __init__(self):
        try:
            self.conn = pg.connect(host="localhost", database="shop_data", user="py_user", password="py_pass", port=6789)
        except pg.Error as e:
            print("I'm unable to connect to the db")
        print("Script has been interpreted and executed")

    def Debug_GetConnectionObject(self):
        return self.conn;

    def CreateTables(self):
        customers_table = """
        CREATE TABLE customers (
        cust_id SERIAL PRIMARY KEY,
        first_nm VARCHAR(100),
        last_nm VARCHAR(100)
        );
        """

        order_table = """
        CREATE TABLE orders (
        order_id SERIAL PRIMARY KEY,
        cust_id integer REFERENCES customers (cust_id), 
        order_dttm TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(20)
        );
        """

        goods_table = """
        CREATE TABLE goods (
        good_id SERIAL PRIMARY KEY,
        vendor VARCHAR(100),
        name VARCHAR(100),
        description VARCHAR(300)
        );
        """

        order_items_table = """
        CREATE TABLE order_items (
        order_item_id SERIAL PRIMARY KEY,
        order_id integer REFERENCES orders (order_id),
        good_id integer REFERENCES goods (good_id),
        quantity integer
        );
        """

        sql_commands = (customers_table, order_table, goods_table, order_items_table);
        try:
            cur = self.conn.cursor()
            for command in sql_commands:
                cur.execute(command)
            self.conn.commit()
            cur.close()
            print("NOTICE: Tables were created ")
        except (Exception, pg.DatabaseError) as error:
            print(error)

    def DropTables(self):
        commands = (
        "DROP TABLE IF EXISTS customers CASCADE;",
        "DROP TABLE IF EXISTS orders CASCADE;",
        "DROP TABLE IF EXISTS goods CASCADE;",
        "DROP TABLE IF EXISTS order_items CASCADE;"
        );
        try:

            cur = self.conn.cursor();
            for command in commands:
                cur.execute(command);
            self.conn.commit();
            cur.close();
            print("NOTICE: Tables were successfully dropped")
        except (Exception, pg.DatabaseError) as error:
            print(error)

    def Close(self):
        self.conn.close()

    def __executeSingleCommand(self, command, parameters):
        try:
            cur = self.conn.cursor()
            cur.execute(command, parameters)
            self.conn.commit()
            cur.close()
        except (Exception, pg.DatabaseError) as error:
            print(error)

    def PlaceOrder(self, cust_id):
        command = "INSERT INTO orders (cust_id, status) VALUES (%s, %s)"
        parameters = (cust_id, "in_process")
        self.__executeSingleCommand(command, parameters)


    def AddGood(self, name, description, vendor):
        command = "INSERT INTO goods (vendor, name, description) VALUES (%s, %s, %s)"
        parameters = (vendor, name, description)
        self.__executeSingleCommand(command, parameters)

    def InsertOrderItem(self, order_id, good_id, quantity):
        command = "INSERT INTO order_items (order_id, good_id, quantity) VALUES (%s, %s, %s)"
        parameters = (order_id, good_id, quantity)
        self.__executeSingleCommand(command, parameters)

    def UpdateOrderItemQuantity(self, order_item_id, quantity):
        command = "UPDATE order_items SET quantity=%s WHERE order_item_id=%s"
        parameters = (quantity, order_item_id)
        self.__executeSingleCommand(command, parameters)

    def RemoveOrderItem(self, order_item_id):
        command = "DELETE FROM order_items WHERE order_item_id=%s"
        parameter = (order_item_id,)
        self.__executeSingleCommand(command, parameter)



    def InitialCommands(self):
        commands = ("INSERT INTO customers (first_nm, last_nm) VALUES ('Nail', 'Iskhakov');",
                   "INSERT INTO customers (first_nm, last_nm) VALUES ('Hypothetical', 'Customer');",
                   "INSERT INTO customers (first_nm, last_nm) VALUES ('Harry', 'Potter');",
                   "INSERT INTO customers (first_nm, last_nm) VALUES ('Hercule', 'Poirot');",
                   "INSERT INTO customers (first_nm, last_nm) VALUES ('Agatha', 'Christie');")
        try:
            cur = self.conn.cursor();
            for command in commands:
                res = cur.execute(command);
                self.conn.commit();
            cur.close();
            print("NOTICE: Customer rows were inserted")
        except (Exception, pg.DatabaseError) as error:
            print(error)

        self.PlaceOrder(1);
        self.PlaceOrder(2);
        self.PlaceOrder(3);
        self.PlaceOrder(1);
        self.AddGood("FerroGematogen", "Affordable healthy bar which has come from the childhood", "UfaVita")
        self.AddGood("Cisco ISR4331R-K9", "Enterprise class router for medium and large companies", "Cisco Inc.")
        self.AddGood("King's Row Extension pack", "Feel and share new experience of realistic atmosphere of King's Row street", "Blizzard Inc.")
        self.InsertOrderItem(1,1,5)
        self.InsertOrderItem(1,2,1)
        self.InsertOrderItem(1,3,10)
        self.InsertOrderItem(2,1,14131)
        self.InsertOrderItem(2,1,15)
        self.InsertOrderItem(3,2,1)
        self.InsertOrderItem(3,1,20)
        self.InsertOrderItem(3,3,1)
        self.InsertOrderItem(4,2,1)
        self.UpdateOrderItemQuantity(2, 3)
        self.RemoveOrderItem(4)

    def ListCustomers(self):
        command = "SELECT * FROM customers;"
        try:
            cur = self.conn.cursor()
            cur.execute(command)
            rows = cur.fetchall()
            for row in rows:
                print("{}: {} {}".format(row[0], row[1], row[2]))
            cur.close()
            return rows;
        except (Exception, pg.DatabaseError) as error:
            print(error)

    def ExportCSV(self, filename):
        command = """
        SELECT order_items.order_id, customers.first_nm, customers.last_nm, goods.name, goods.vendor, order_items.quantity
        FROM order_items 
        JOIN orders ON orders.order_id = order_items.order_id
        JOIN customers ON customers.cust_id = orders.cust_id
        JOIN goods ON goods.good_id = order_items.good_id
        ORDER BY order_items.order_id
        """
        try:
            cur = self.conn.cursor()
            cur.execute(command)
            entries = cur.fetchall()
            cur.close()
        except (Exception, pg.DatabaseError) as error:
            print(error)
            return

        Data = [["Order #", "First name", "Last name", "Good", "Vendor", "Quantity"]]
        for entry in entries:
            Data.append(list(entry))
        File = open(filename, "w")
        with File:
            writer = csv.writer(File)
            writer.writerows(Data)
        print("The order data were written to '{}' file ".format(filename))





if __name__ == "__main__":
    print("Executing testing script on main \n" +
          "The output will be a csv file output.csv. \n" +
          "The script temporarily create tables, after program finishes tables will be dropped\n\n")
    db = ShopDataClass();
    db.DropTables()
    db.CreateTables()
    db.InitialCommands()
    db.ExportCSV("output.csv")
    db.DropTables()
    db.Close()
