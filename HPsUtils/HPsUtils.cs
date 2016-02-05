using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    public static class HPsUtils
    {
        public class HelpItem
        {
            public string ReturnType { get; set; }
            public string FuncName { get; set; }
            public List<string> ParamList { get; set; }
        }

        public static List<HelpItem> help()
        {
            var result = new List<HelpItem>();
            var methodList = typeof(HPsUtils).GetMethods();

            foreach (var m in methodList)
            {
                if (!m.IsPublic)
                    continue;

                if (m.IsVirtual)
                    continue;



                var helpItem = new HelpItem();
                result.Add(helpItem);
                helpItem.ReturnType = m.ReturnType.Name;
                helpItem.FuncName = m.Name;
                helpItem.ParamList = new List<string>();

                foreach (var param in m.GetParameters())
                {
                    helpItem.ParamList.Add($"{param.ParameterType.Name} {param.Name}");
                }
            }

            return result;
        }

        public static void Zip(string dir, string zipFile)
        {
            try
            {
                ZipFile.CreateFromDirectory(dir, zipFile);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        public static void Unzip(string dir, string zipFile)
        {
            try
            {
                ZipFile.ExtractToDirectory(zipFile, dir);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        public static string DoubleStr(string str)
        {
            return str + str;
        }












        [TestClass]
        public class _Test
        {
            [TestMethod]
            public void help()
            {
                HPsUtils.help();
            }
        }
    }


}
