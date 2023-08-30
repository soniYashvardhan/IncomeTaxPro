import mysql.connector
import streamlit as st
import pandas as pd


def main():
	st.title("Tax Management System")
	query = st.text_area("Enter any sql query to be run", placeholder="Select * from user")
	if(st.button("Run query")):
		c.execute(query)
		st.dataframe(c.fetchall())
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