import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `income_type_id` int(5) NOT NULL,
	    `Gross Salary` int DEFAULT NULL,
	    `CTC` int DEFAULT NULL,
	    `taxable_amt` int DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, income_type_id, Gross_Salary, CTC, taxable_amt):
    c.execute(f'INSERT INTO {table_name} VALUES ("{income_type_id}", {Gross_Salary}, {CTC}, {taxable_amt})')
    db.commit()


def view():
    c.execute('select * from salary')
    return c.fetchall()

def delete_record(income_type_id):
    c.execute(f'delete from salary where income_type_id = "{income_type_id}"')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update salary SET `{attrichoice}` = "{updated_attri}" where income_type_id = {choice}')
    db.commit()

def get_user(income_type_id):
    c.execute(f'select * from salary where income_type_id = {income_type_id}')
    return c.fetchall()


def create():
    income_type_id = st.text_input("income_type_id: ")
    Gross_Salary = st.number_input("Gross Salary: ")
    CTC = st.number_input("CTC: ")
    taxable_amt = st.number_input("taxable_amt: ")
    if st.button("Add Salary"):
        add_data("Salary", income_type_id, Gross_Salary, CTC, taxable_amt)
        st.success("Successfully added record!")


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['income_type_id', 'Gross Salary', 'CTC', 'taxable_amt']))
    income_type_ids = [i[0] for i in data]
    choice_type_id = st.selectbox('Select income_type_id to delete', income_type_ids)
    if st.button('Delete Record'):
        delete_record(choice_type_id)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['income_type_id', 'Gross Salary', 'CTC', 'taxable_amt']))
    income_type_ids = [i[0] for i in data]
    choice_type_id = st.selectbox('Select income_type_id to delete', income_type_ids)
    data = get_user(choice_type_id)
    if data:
        attri = ['income_type_id', 'Gross Salary', 'CTC', 'taxable_amt']
        attrichoice = st.selectbox('Select attribute to update', attri)
        updated_attri = st.text_input(f"Enter a new value for {attrichoice}")
        if updated_attri == '':
            updated_attri = data[0][attri.index(attrichoice)]
        if st.button("Update"):
            update(choice_type_id, attrichoice, updated_attri)
            st.success("Updated!")


def main():
    st.title("Tax Management System")
    menu = ["Add", "View", "Edit", "Remove"]
    choice = st.sidebar.selectbox("Menu", menu)
    create_table("salary")
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
        df = pd.DataFrame(data, columns = ['income_type_id', 'Gross Salary', 'CTC', 'taxable_amt'])
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