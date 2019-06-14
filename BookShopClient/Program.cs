using System;
using System.Text;
using System.Net;
using System.Net.Sockets;

namespace BookShopClient
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                SendMessageFromSocket(11000);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            finally
            {
                Console.ReadLine();
            }
        }

        static void SendMessageFromSocket(int port)
        {
            // буфер
            byte[] bytes = new byte[1024];
            // конфигурация
            IPHostEntry ipHost = Dns.GetHostEntry("localhost");
            IPAddress ipAddr = ipHost.AddressList[0];
            IPEndPoint ipEndPoint = new IPEndPoint(ipAddr, port);
            Socket sender = new Socket(ipAddr.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
            // соединение
            sender.Connect(ipEndPoint);
            Console.Write("You: ");
            string message = Console.ReadLine();
            byte[] msg = Encoding.UTF8.GetBytes(message);
            int bytesSent = sender.Send(msg);
            int bytesRec = sender.Receive(bytes);
            Console.WriteLine("Support: {0}", Encoding.UTF8.GetString(bytes, 0, bytesRec));
            // рекурсия для продолжения работы, условие стоп слово
            if (message.IndexOf("<TheEnd>") == -1)
                SendMessageFromSocket(port);
            sender.Shutdown(SocketShutdown.Both);
            sender.Close();
        }
    }
}
