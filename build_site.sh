cd sphinx_docs
make clean
make html
rm -r ../docs
mv build/html ../docs
cd ..
open docs/index.html
