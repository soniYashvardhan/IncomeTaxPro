import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `reimbursement_id` int NOT NULL,
	    `type` varchar(20) DEFAULT NULL,
	    `amt` int DEFAULT NULL,
	    `date` DATE DEFAULT NULL,
	    `income_type_id` int(5) DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, reimbursement_id, type, amt, date, income_type_id):
    c.execute(f'INSERT INTO {table_name} VALUES ({reimbursement_id}, "{type}", {amt}, "{date}", {income_type_id})')
    db.commit()


def view():
    c.execute('select * from reimbursements')
    return c.fetchall()

def delete_record(reimbursement_id):
    c.execute(f'delete from reimbursements where reimbursement_id = "{reimbursement_id}"')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update reimbursements SET `{attrichoice}` = "{updated_attri}" where reimbursement_id = {choice}')
    db.commit()

def get_user(reimbursement_id):
    c.execute(f'select * from reimbursements where reimbursement_id = {reimbursement_id}')
    return c.fetchall()


def create():
    reimbursement_id = st.number_input("reimbursement_id: ")
    type = st.text_input("Type of Reimbursement: ")
    amt = st.number_input("Amount: ")
    date = st.date_input("date when claimed: ")
    income_type_id = st.text_input("income_type_id: ")
    if st.button("Add reimbursements"):
        add_data("reimbursements", reimbursement_id, type, amt, date, income_type_id)
        st.success("Successfully added record!")


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['reimbursement_id', 'type', 'amt', 'date', 'income_type_id']))
    ids = [i[0] for i in data]
    choice_id = st.selectbox('Select reimbursement_id to delete', ids)
    if st.button('Delete Record'):
        delete_record(choice_id)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['reimbursement_id', 'type', 'amt', 'date', 'income_type_id']))
    ids = [i[0] for i in data]
    choice_id = st.selectbox('Select reimbursement_id to delete', ids)
    data = get_user(choice_id)
    if data:
        attri = ['reimbursement_id', 'type', 'amt', 'date', 'income_type_id']
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
    create_table("reimbursements")
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
        df = pd.DataFrame(data, columns = ['reimbursement_id', 'type', 'amt', 'date', 'income_type_id'])
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