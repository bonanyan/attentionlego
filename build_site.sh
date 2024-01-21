cd sphinx_docs
make clean
make html
rm -r ../docs
mv build/html ../docs
cd ..
touch docs/.nojekyll
open docs/index.html
