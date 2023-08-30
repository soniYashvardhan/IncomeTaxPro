import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `user_id` int(5) NOT NULL,
	    `FName` varchar(20) NOT NULL,
	    `LName` varchar(20) DEFAULT NULL,
	    `Age` int DEFAULT NULL,
	    `Phone_no` int(10) DEFAULT NULL,
	    `Address Permanent` varchar(255) NOT NULL,
	    `Address Residentual` varchar(255) DEFAULT NULL,
	    `income_id` varchar(10) NOT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, user_id, Fname, Lname, Age, Phone_no, Permanent, Residentual, income_id):
    c.execute(f'INSERT INTO {table_name} VALUES ({user_id},"{Fname}","{Lname}", {Age}, {Phone_no}, "{Permanent}", "{Residentual}", "{income_id}")')
    db.commit()


def view():
    c.execute('select * from user')
    return c.fetchall()

def delete_record(user_id):
    c.execute(f'delete from user where user_id = "{user_id}"')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update user SET `{attrichoice}` = "{updated_attri}" where user_id = "{choice}"')
    db.commit()

def get_user(user_id):
    c.execute(f'select * from user where user_id = "{user_id}"')
    return c.fetchall()


def create():
    user_id = st.text_input("user_id: ")
    Fname = st.text_input("Fname: ")
    Lname = st.text_input("Lname: ")
    Age = st.text_input("Age: ")
    Phone_no = st.text_input("Phone_no: ")
    Permanent = st.text_input("Address Permanent: ")
    Residentual = st.text_input("Address Residentual: ")
    income_id = st.text_input("income_id: ")
    if st.button("Add User"):
        add_data("user", user_id, Fname, Lname, Age, Phone_no, Permanent, Residentual, income_id)
        st.success("Successfully added record!")


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['user_id', 'Fname', 'Lname', 'Age', 'Phone_no', 'Address Permanent','Address Residentual','income_id']))
    user_ids = [i[0] for i in data]
    choice = st.selectbox('Select user to delete', user_ids)
    if st.button('Delete Record'):
        delete_record(choice)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['user_id', 'Fname', 'Lname', 'Age', 'Phone_no', 'Address Permanent','Address Residentual','income_id']))
    user_ids = [i[0] for i in data]
    choice = st.selectbox('Select user_id', user_ids)
    data = get_user(choice)
    if data:
        attri = ['user_id', 'Fname', 'Lname', 'Age', 'Phone_no', 'Address Permanent','Address Residentual','income_id']
        attrichoice = st.selectbox('Select attribute to update', attri)
        updated_attri = st.text_input(f"Enter a new value for {attrichoice}")
        if updated_attri == '':
            updated_attri = data[0][attri.index(attrichoice)]
        if st.button("Update"):
            update(choice, attrichoice, updated_attri)
            st.success("Updated!")


def main():
    st.title("Tax Management System")
    menu = ["Add", "View", "Edit", "Remove"]
    choice = st.sidebar.selectbox("Menu", menu)
    create_table("user")
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
        df = pd.DataFrame(data, columns = ['user_id', 'Fname', 'Lname', 'Age', 'Phone_no', 'Address Permanent','Address Residentual','income_id'])
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