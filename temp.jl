using PkgTemplates

t = Template(;
           user = "ac2368",
           authors = ["Amelia Bielby, Arushi Chauhan, Cassia Pearce, Yue Ren"],
           plugins = [
               License(name = "MIT"),
               Git(),
               GitHubActions(),
           ],
       )

t("SummerProject2025")
