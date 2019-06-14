using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.Sql;
using System.Data.SqlClient;
using System.IO;


namespace BookShop
{
    public partial class Bookstore : Form
    {
        public static string loguser;
        public string[] PickedBooksName = { };
        public int[] PickedBooksAmount = { };
        public string[] PickedBooksOrder = new string[1];
        public static string path = @"C:\Users\herma\source\repos\BookShop\BookShop\Data\base-islamov.mdf";
        public Bookstore()
        {
            InitializeComponent();
        }
        public void LogStatusChange()
        {
            LoginStatus.Text = "You are logged in as "+loguser;
            FileMenuLogin.Text = "Change Login";
            OrderMenuMake.Enabled = true;
            OrderMenuMyOrders.Enabled = true;
        }
        private void Bookstore_Load(object sender, EventArgs e)
        {
            PickedBooksOrder[0]= "Id \t Book \t \t Amount \n";
            PickedOrder.Text = PickedBooksOrder[0];
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            IDbConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            string query = "select book_name from book";
            IDbCommand command = new SqlCommand(query);
            command.Connection = connection;
            IDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                object book = reader.GetValue(0);
                BookSelector.Items.Add(book);
            }
            reader.Close();

            query = "select author_name from authors";
            command = new SqlCommand(query);
            command.Connection = connection;
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                object obj = reader.GetValue(0);
                AuthorBookSelector.Items.Add(obj);
            }
            reader.Close();
            
            query = "select genre_name from genres";
            command = new SqlCommand(query);
            command.Connection = connection;
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                object obj = reader.GetValue(0);
                GenreBookSelector.Items.Add(obj);
            }
            reader.Close();
            
            query = "select publisher_name from publishers";
            command = new SqlCommand(query);
            command.Connection = connection;
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                object obj = reader.GetValue(0);
                PublisherBookSelector.Items.Add(obj);
            }
            reader.Close();

            command.Dispose();
            connection.Close();
        }

        private void loginToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Login LoginSequence = new Login();
            LoginSequence.Owner=this;
            LoginSequence.Show();
        }

        private void AuthorBookSelector_SelectedValueChanged(object sender, EventArgs e)
        {
            CategoryBookSelector.Items.Clear();
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            IDbConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            SqlParameter sqlParameter = new SqlParameter("@aut", SqlDbType.VarChar, 255);
            sqlParameter.Value = AuthorBookSelector.SelectedItem.ToString();
            IDbCommand command = new SqlCommand("authorp");
            command.CommandType = CommandType.StoredProcedure;
            command.Connection = connection;
            command.Parameters.Add(sqlParameter);
            command.Prepare();
            IDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                object book = reader.GetValue(0);
                CategoryBookSelector.Items.Add(book);
            }
            reader.Close();
            command.Dispose();
            connection.Close();
            GenreBookSelector.Text = "";
            PublisherBookSelector.Text = "";
        }

        private void GenreBookSelector_SelectedValueChanged(object sender, EventArgs e)
        {
            CategoryBookSelector.Items.Clear();
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            IDbConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            SqlParameter sqlParameter = new SqlParameter("@gen", SqlDbType.VarChar, 255);
            sqlParameter.Value = GenreBookSelector.SelectedItem.ToString();
            IDbCommand command = new SqlCommand("genrep");
            command.CommandType = CommandType.StoredProcedure;
            command.Connection = connection;
            command.Parameters.Add(sqlParameter);
            command.Prepare();
            IDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                object book = reader.GetValue(0);
                CategoryBookSelector.Items.Add(book);
            }
            reader.Close();
            command.Dispose();
            connection.Close();
            AuthorBookSelector.Text = "";
            PublisherBookSelector.Text = "";
        }

        private void PublisherBookSelector_SelectedValueChanged(object sender, EventArgs e)
        {
            CategoryBookSelector.Items.Clear();
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            IDbConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            SqlParameter sqlParameter = new SqlParameter("@pub", SqlDbType.VarChar, 255);
            sqlParameter.Value = PublisherBookSelector.SelectedItem.ToString();
            IDbCommand command = new SqlCommand("publishp");
            command.CommandType = CommandType.StoredProcedure;
            command.Connection = connection;
            command.Parameters.Add(sqlParameter);
            command.Prepare();
            IDataReader reader = command.ExecuteReader();
            while (reader.Read())
            {
                object book = reader.GetValue(0);
                CategoryBookSelector.Items.Add(book);
            }
            reader.Close();
            command.Dispose();
            connection.Close();
            GenreBookSelector.Text = "";
            AuthorBookSelector.Text = "";
        }

        private void FileMenuExit_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void SubmitBook_Click(object sender, EventArgs e)
        {
            if (AmountBox.Text != "")
            {
                if ((Convert.ToInt32(AmountBox.Text) != Convert.ToDouble(AmountBox.Text)) || (Convert.ToInt32(AmountBox.Text) <= 0))
                {
                    MessageBox.Show("The Amount of Books must be a Natural Number");
                    return;
                }
            }
            else
            {
                MessageBox.Show("The Amount of Books must be filled");
                return;
            }
            if(BookSelector.SelectedIndex>-1)
            {
                Array.Resize(ref PickedBooksAmount, PickedBooksAmount.Length + 1);
                Array.Resize(ref PickedBooksName, PickedBooksName.Length + 1);
                Array.Resize(ref PickedBooksOrder, PickedBooksOrder.Length + 1);
                PickedBooksName[PickedBooksName.Length - 1] = BookSelector.SelectedItem.ToString();
                BookSelector.Text = "";
                PickedBooksAmount[PickedBooksAmount.Length - 1] = Convert.ToInt32(AmountBox.Text.ToString());
                AmountBox.Text = "";
                PickedBooksOrder[PickedBooksName.Length] = (PickedBooksName.Length - 1) + " " + PickedBooksName[PickedBooksName.Length - 1] + " " + PickedBooksAmount[PickedBooksAmount.Length - 1] + "\n";
                PickedOrder.Text += PickedBooksOrder[PickedBooksName.Length];
                DeletePicked.Items.Add(PickedBooksName.Length - 1);
            }
            else
            {
                if (CategoryBookSelector.SelectedIndex>-1)
                {
                    Array.Resize(ref PickedBooksAmount, PickedBooksAmount.Length + 1);
                    Array.Resize(ref PickedBooksName, PickedBooksName.Length + 1);
                    Array.Resize(ref PickedBooksOrder, PickedBooksOrder.Length + 1);
                    PickedBooksName[PickedBooksName.Length - 1] = CategoryBookSelector.SelectedItem.ToString();
                    CategoryBookSelector.Text = "";
                    PickedBooksAmount[PickedBooksAmount.Length - 1] = Convert.ToInt32(AmountBox.Text.ToString());
                    AmountBox.Text = "";
                    PickedBooksOrder[PickedBooksName.Length] = (PickedBooksName.Length - 1) + " " + PickedBooksName[PickedBooksName.Length - 1] + " " + PickedBooksAmount[PickedBooksAmount.Length - 1] + "\n";
                    PickedOrder.Text += PickedBooksOrder[PickedBooksName.Length];
                    DeletePicked.Items.Add(PickedBooksName.Length - 1);
                }
                else
                {
                    MessageBox.Show("You must choose a book to add to order");
                    return;
                }
            }
        }

        private void OrderMenuMake_Click(object sender, EventArgs e)
        {
            BookChoicePanel.Visible = true;
            PickedBooksPanel.Visible = true;
        }

        private void OrderMenuMyOrders_Click(object sender, EventArgs e)
        {
            MyOrdersPanel.Visible = true;
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            SqlConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            SqlParameter sqlParameter = new SqlParameter("@usr", SqlDbType.VarChar, 255);
            sqlParameter.Value = loguser;
            SqlCommand command = new SqlCommand("user_orders");
            
            command.CommandType = CommandType.StoredProcedure;
            command.Connection = connection;
            command.Parameters.Add(sqlParameter);
            command.Prepare();
            SqlDataAdapter adapter = new SqlDataAdapter(command);
            DataTable table = new DataTable();
            adapter.Fill(table);
            MyOrdersDGV.DataSource = table;
            IDataReader reader = command.ExecuteReader();
            //MyOrdersOutput.Text = "Order ID \t Order Date \t Amount \t Book \t Author \t Genre \t Publisher \t Publication Year \n";
            while (reader.Read())
            {
                object id = reader.GetValue(0);
                object date = reader.GetValue(1);
                object amount = reader.GetValue(2);
                object book = reader.GetValue(3);
                object author = reader.GetValue(4);
                object genre = reader.GetValue(5);
                object publisher = reader.GetValue(6);
                object year = reader.GetValue(7);
                //MyOrdersOutput.Text += id+" \t "+date+" \t "+amount+ " \t " + book+ " \t " + author+ " \t " + genre+ " \t " + publisher+ " \t " + year+" \n";
            }
            reader.Close();
            command.Dispose();
            connection.Close();
        }

        private void SubmitOrder_Click(object sender, EventArgs e)
        {
            PickedBooksName = PickedBooksName.Where(x => x != null).ToArray();
            PickedBooksAmount = PickedBooksAmount.Where(x => x != 0).ToArray();

            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = @"(LocalDB)\MSSQLLocalDB";
            builder.AttachDBFilename = path;
            builder.IntegratedSecurity = true;

            IDbConnection connection = new SqlConnection(builder.ConnectionString);
            connection.Open();

            SqlParameter sqlParameter = new SqlParameter("@log", SqlDbType.VarChar, 255);
            sqlParameter.Value = loguser;
            IDbCommand command = new SqlCommand("InsOrd");
            command.CommandType = CommandType.StoredProcedure;
            command.Connection = connection;
            command.Parameters.Add(sqlParameter);
            command.Prepare();
            command.ExecuteNonQuery();
            SqlParameter parameter;
            for(int i=0;i<PickedBooksAmount.Length;i++)
            {
                sqlParameter = new SqlParameter("@quan", SqlDbType.VarChar, 255);
                sqlParameter.Value = PickedBooksAmount[i];
                parameter =  new SqlParameter("@bok", SqlDbType.VarChar, 255);
                parameter.Value = PickedBooksName[i];
                command = new SqlCommand("InsShop");
                command.CommandType = CommandType.StoredProcedure;
                command.Connection = connection;
                command.Parameters.Add(sqlParameter);
                command.Parameters.Add(parameter);
                command.Prepare();
                command.ExecuteNonQuery();
            }
           
            command.Dispose();
            connection.Close();
            MessageBox.Show("Order Accepted");
            Array.Clear(PickedBooksName, 0, PickedBooksName.Length);
            Array.Clear(PickedBooksAmount, 0, PickedBooksAmount.Length);
            Array.Clear(PickedBooksOrder, 0, PickedBooksOrder.Length);
            PickedBooksOrder[0] = "Id \t Book \t \t Amount \n";
            PickedOrder.Text = PickedBooksOrder[0];
            OrderMenuMyOrders_Click(sender,e);
        }

        private void DeletePickedSubmit_Click(object sender, EventArgs e)
        {
            if(DeletePicked.SelectedIndex>-1)
            {
                //PickedOrder.Text.IndexOf(PickedBooksName[DeletePicked.SelectedIndex]);
                PickedBooksOrder[Convert.ToInt32(DeletePicked.SelectedItem) + 1] = "";
                PickedOrder.Text = "";
                Array.Clear(PickedBooksName, Convert.ToInt32(DeletePicked.SelectedItem), 1);
                Array.Clear(PickedBooksAmount, Convert.ToInt32(DeletePicked.SelectedItem), 1);
                for(int i=0;i<PickedBooksOrder.Length;i++)
                {
                    PickedOrder.Text += PickedBooksOrder[i];
                }
                DeletePicked.Items.Remove(Convert.ToInt32(DeletePicked.SelectedItem));
                DeletePicked.ResetText();
            }
        }

        private void HelpMenuAbout_Click(object sender, EventArgs e)
        {
            using (AboutBox dialog = new AboutBox())
            {
                dialog.ShowDialog();
            }
        }

        private void HelpMenuContact_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(@"C:\Users\herma\source\repos\BookShop\BookShopClient\bin\Debug\BookShopClient.exe");
        }

    }
}
