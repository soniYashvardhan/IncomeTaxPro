import mysql.connector
import streamlit as st
import pandas as pd


def update_tax():
	id = st.text_input("Enter Income id: ")
	type_id = st.text_input("Enter Income type id: ")
	if(st.button("Update")):
		c.execute(f'CALL update_total_tax("{id}",{type_id}, @A)')
		c.execute(f'SELECT @A')
		st.write(c.fetchall()[0][0])
		st.write("Table after the update: ")
		c.execute("SELECT * from income")
		st.dataframe(c.fetchall())
		db.commit()

def add_data(table_name, id, stock_symbol, Purchase_date, Sell_date, quantity, amt, ca_id):
    c.execute(f'INSERT INTO {table_name} VALUES ({id}, "{stock_symbol}", "{Purchase_date}", "{Sell_date}", {quantity}, {amt}, {ca_id})')
    db.commit()

def create():
	id = st.number_input("id: ")
	stock_symbol = st.text_input("Stock Symbol: ")
	Purchase_date = st.date_input("Purchase Date of stock: ")
	Sell_date = st.date_input("Sell Date of Stock: ")
	quantity = st.number_input("quantity: ")
	amt = st.number_input("amt: ")
	ca_id = st.number_input("ca_id: ")
	if st.button("Add stocks"):
		try:
			add_data("stocks", id, stock_symbol, Purchase_date, Sell_date, quantity, amt, ca_id)
			st.success("Successfully added record!")
		except Exception as e:
			st.write(e)


def main():
	st.title("Tax Management System")
	menu = ["Update total tax for capital assets", "Find number of assets each user has", "Check Trigger (Purchase date should be before Sell Date)", "Run a cursor to backup income table"]
	choice = st.sidebar.selectbox("Menu", menu)
	if choice == menu[0]:
		st.subheader("Update total tax on capital assets for a user")
		try:
			update_tax()
		except:
			st.error("Error!")

	elif choice == menu[1]:
		st.subheader("Find number of assets each user has")
		if(st.button('Check Function')):
			try:
				c.execute("SELECT U.Fname, U.LName, no_of_assets(I.income_type_id) FROM user U NATURAL JOIN income I WHERE I.income_type like 'Capital Assets'")
				data = c.fetchall()
			except:
				st.error("Error!")
			df = pd.DataFrame(data, columns = ['Fname', 'Lname', 'no_of_assets'])
			st.dataframe(df)
		
	elif choice == menu[2]:
		st.subheader("Enter details")
		create()

	elif choice == menu[3]:
		st.subheader('Run backup cursor')
		if(st.button("Cursor!")):
			c.execute("delete from backup_income")
			c.execute("CALL backup")
			c.execute("SELECT * from backup_income")
			st.dataframe(pd.DataFrame(c.fetchall(), columns= ['income_id', 'tax_slab', 'total_tax', 'total_income', 'income_type', 'income_type_id']))
			db.commit()

if __name__ == '__main__':
    db = mysql.connector.connect(
        host = 'localhost',
        user = 'root',
        password = '',
        database = 'taxms'
    )
    c = db.cursor()

main()