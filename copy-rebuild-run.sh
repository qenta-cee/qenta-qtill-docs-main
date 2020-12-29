make ui.build
#rm -r content/online-guides/modules/ROOT/pages/* content/online-guides/modules/ROOT/assets
#cp $HOME/Work/git/og2asciidoc/pages/start.adoc content/online-guides/modules/ROOT/pages/index.adoc
#cp -r $HOME/Work/git/og2asciidoc/pages/* content/online-guides/modules/ROOT/pages/
#mkdir -p content/online-guides/modules/ROOT/assets/
#cp -r $HOME/Work/git/og2asciidoc/{images,attachments} content/online-guides/modules/ROOT/assets/

# mkdir -p content/online-guides/modules/ROOT/assets/attachments/
# mkdir -p content/online-guides/modules/ROOT/assets/images/

# cp -r $HOME/Work/git/og2asciidoc/
# cp -r $HOME/Work/git/og2asciidoc/pages/*
make antora.build
make antora.run
