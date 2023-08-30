import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `ca_id` int NOT NULL,
	    `assest_type` varchar(20) DEFAULT NULL,
	    `profit` int DEFAULT NULL,
	    `gain` int DEFAULT NULL,
	    `income_type_id` int(5) DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, ca_id, assest_type, profit, gain, income_type_id):
    c.execute(f'INSERT INTO {table_name} VALUES ("{ca_id}", {assest_type}, {profit}, {gain}, {income_type_id})')
    db.commit()


def view():
    c.execute('select * from capitalassets')
    return c.fetchall()

def delete_record(ca_id):
    c.execute(f'delete from capitalassets where ca_id = "{ca_id}"')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update capitalassets SET `{attrichoice}` = "{updated_attri}" where ca_id = {choice}')
    db.commit()

def get_user(ca_id):
    c.execute(f'select * from capitalassets where ca_id = {ca_id}')
    return c.fetchall()


def create():
    ca_id = st.number_input("ca_id: ")
    assest_type = st.text_input("assest_type: ")
    profit = st.number_input("profit: ")
    gain = st.number_input("gain: ")
    income_type_id = st.text_input("income_type_id: ")
    if st.button("Add Capital Asset"):
        add_data("capitalassets", ca_id, assest_type, profit, gain, income_type_id)
        st.success("Successfully added record!")


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['ca_id', 'assest_type', 'profit', 'gain', 'income_type_id']))
    ca_ids = [i[0] for i in data]
    choice_id = st.selectbox('Select ca_id to delete', ca_ids)
    if st.button('Delete Record'):
        delete_record(choice_id)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['ca_id', 'assest_type', 'profit', 'gain', 'income_type_id']))
    ca_ids = [i[0] for i in data]
    choice_id = st.selectbox('Select ca_id to delete', ca_ids)
    data = get_user(choice_id)
    if data:
        attri = ['ca_id', 'assest_type', 'profit', 'gain', 'income_type_id']
        attrichoice = st.selectbox('Select attribute to update', attri)
        updated_attri = st.text_input(f"Enter a new value for {attrichoice}")
        if updated_attri == '':
            updated_attri = data[0][attri.index(attrichoice)]
        if st.button("Update"):
            update(choice_id, attrichoice, updated_attri)
            st.success("Updated!")


def main():
    st.title("Tax Management System")
    menu = ["Add", "View", "Edit", "Remove"]
    choice = st.sidebar.selectbox("Menu", menu)
    create_table("capitalassets")
    if choice == 'Add':
        st.subheader("Enter details")
        try:
            create()
        except:
            st.error("Error!")
    elif choice == 'View':
        st.subheader("Information in Table")
        try:
            data = view()
        except:
            st.error("Error!")
        df = pd.DataFrame(data, columns = ['ca_id', 'assest_type', 'profit', 'gain', 'income_type_id'])
        st.dataframe(df)
    
    elif choice == 'Remove':
        st.subheader('Select row to delete')
        delete()
    elif choice == 'Edit':
        st.subheader('Select row to update')
        edit()


if __name__ == '__main__':
    db = mysql.connector.connect(
        host = 'localhost',
        user = 'root',
        password = '',
        database = 'taxms'
    )
    c = db.cursor()

main()