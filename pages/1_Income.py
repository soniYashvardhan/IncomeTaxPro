import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `income_id` varchar(10) NOT NULL,
  	    `tax_slab` int DEFAULT NULL,
	    `total_tax` int DEFAULT NULL,
	    `total_income` int DEFAULT NULL,
	    `income_type` varchar(20) NOT NULL,
	    `income_type_id` int(5) NOT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, income_id, tax_slab, total_tax, total_income, income_type, income_type_id):
    c.execute(f'INSERT INTO {table_name} VALUES ("{income_id}",{tax_slab},{total_tax}, {total_income}, "{income_type}", {income_type_id})')
    db.commit()


def view():
    c.execute('select * from income')
    return c.fetchall()

def delete_record(income_id, income_type_id):
    c.execute(f'delete from income where income_id = "{income_id}" and income_type_id = {income_type_id}')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update income SET `{attrichoice}` = "{updated_attri}" where income_id = "{choice[0]}" and income_type_id = {choice[1]}')
    db.commit()

def get_user(income_id, income_type_id):
    c.execute(f'select * from income where income_id = "{income_id}" and income_type_id = {income_type_id}')
    return c.fetchall()


def create():
    income_id = st.text_input("income_id: ")
    tax_slab = st.number_input("tax_slab: ")
    total_tax = st.number_input("total_tax: ")
    total_income = st.number_input("total_income: ")
    income_type = st.text_input("income_type: ")
    income_type_id = st.text_input("income_type_id: ")
    if st.button("Add Income"):
        add_data("Income", income_id, tax_slab, total_tax, total_income, income_type, income_type_id)
        st.success("Successfully added record!")
    if(st.button("View with name: ")):
        c.execute('SELECT user.user_id, user.Fname, user.LName, income.total_tax, income.total_income, income.income_type, income.income_type_id FROM user NATURAL JOIN income')
        data = c.fetchall()
        df = pd.DataFrame(data, columns = ['user_id', 'Fname', 'LName', 'total_tax', 'total_income', 'income_type', 'income_type_id'])
        st.dataframe(df)


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['income_id', 'tax_slab', 'total_tax', 'total_income', 'income_type', 'income_type_id']))
    income_ids = [i[0] for i in data]
    income_type_ids = [i[5] for i in data]
    choice_id = st.selectbox('Select income_id to delete', income_ids)
    choice_type_id = st.selectbox('Select income_type_id to delete', income_type_ids)
    if st.button('Delete Record'):
        delete_record(choice_id, choice_type_id)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['income_id', 'tax_slab', 'total_tax', 'total_income', 'income_type', 'income_type_id']))
    income_ids = [i[0] for i in data]
    income_type_ids = [i[5] for i in data]
    choice_id = st.selectbox('Select income_id to delete', income_ids)
    choice_type_id = st.selectbox('Select income_type_id to delete', income_type_ids)
    data = get_user(choice_id, choice_type_id)
    if data:
        attri = ['income_id', 'tax_slab', 'total_tax', 'total_income', 'income_type', 'income_type_id']
        attrichoice = st.selectbox('Select attribute to update', attri)
        updated_attri = st.text_input(f"Enter a new value for {attrichoice}")
        if updated_attri == '':
            updated_attri = data[0][attri.index(attrichoice)]
        if st.button("Update"):
            update((choice_id, choice_type_id), attrichoice, updated_attri)
            st.success("Updated!")


def main():
    st.title("Tax Management System")
    menu = ["Add", "View", "Edit", "Remove"]
    choice = st.sidebar.selectbox("Menu", menu)
    create_table("income")
    if choice == 'Add':
        st.subheader("Enter details")
        # try:
        create()
        # except:
            # st.error("Error!")
    elif choice == 'View':
        st.subheader("Information in Table")
        try:
            data = view()
        except:
            st.error("Error!")
        df = pd.DataFrame(data, columns = ['income_id', 'tax_slab', 'total_tax', 'total_income', 'income_type', 'income_type_id'])
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