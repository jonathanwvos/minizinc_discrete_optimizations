This repository holds code and examples for the coursera beginner course on discrete optmizations in minizinc, including my own attempts and experiments.

For more information on minizinc refer to https://www.minizinc.org/

There is also a notebook in which I experimented with running minizinc in a python environment, for this you'll need iminizinc. It will allow you to run minizinc commands using jupyter notebook cell magic

If you're using the minizinc IDE then no additional configuration is required.

If you're using the command line or jupyter notebooks then additional configuration is required.

To setup environment run:
```sh
conda create -n minizinc
conda activate minizinc
pip install -r requirements.txt
```

**NOTE**: If you're using windows, you'll need to add minizinc to your `PATH`
