import mysql.connector
import streamlit as st
import pandas as pd


def create_table(table_name: str):
    c.execute(f"""CREATE TABLE IF NOT EXISTS {table_name}(
        `id` int NOT NULL,
	    `type` varchar(20) DEFAULT NULL,
	    `Name` varchar(255) NOT NULL,
	    `age` int DEFAULT NULL,
	    `duration` int DEFAULT NULL,
	    `amt` int DEFAULT NULL,
	    `income_type_id` int(5) DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4""")

def add_data(table_name, id, type, Name, age, duration, amt, income_type_id):
    c.execute(f'INSERT INTO {table_name} VALUES ({id}, "{type}", "{Name}", {age}, {duration}, {amt}, {income_type_id})')
    db.commit()


def view():
    c.execute('select * from insurance')
    return c.fetchall()

def delete_record(id):
    c.execute(f'delete from insurance where id = "{id}"')
    db.commit()

def update(choice, attrichoice, updated_attri):
    c.execute(f'update insurance SET `{attrichoice}` = "{updated_attri}" where id = {choice}')
    db.commit()

def get_user(id):
    c.execute(f'select * from insurance where id = {id}')
    return c.fetchall()


def create():
    id = st.number_input("id: ")
    type = st.text_input("type: ")
    Name = st.text_input("Name: ")
    age = st.number_input("age: ")
    duration = st.number_input("duration: ")
    amt = st.number_input("amt: ")
    income_type_id = st.text_input("income_type_id: ")
    if st.button("Add Insurance"):
        add_data("insurance", id, type, Name, age, duration, amt, income_type_id)
        st.success("Successfully added record!")


def delete():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['id', 'type', 'Name', 'age', 'duration', 'amt', 'income_type_id']))
    ids = [i[0] for i in data]
    choice_id = st.selectbox('Select id to delete', ids)
    if st.button('Delete Record'):
        delete_record(choice_id)
        st.experimental_rerun()


def edit():
    data = view()
    st.dataframe(pd.DataFrame(data, columns = ['id', 'type', 'Name', 'age', 'duration', 'amt', 'income_type_id']))
    ids = [i[0] for i in data]
    choice_id = st.selectbox('Select id to delete', ids)
    data = get_user(choice_id)
    if data:
        attri = ['id', 'type', 'Name', 'age', 'duration', 'amt', 'income_type_id']
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
    create_table("insurance")
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
        df = pd.DataFrame(data, columns = ['id', 'type', 'Name', 'age', 'duration', 'amt', 'income_type_id'])
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