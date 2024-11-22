FROM paperist/texlive-ja:latest

RUN apt-get update && \
    apt-get install -y \
        git \
        cpanminus \
        texlive-extra-utils \
        make \
        biber \
        pandoc \
        chktex \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cpanm Log::Log4perl Log::Dispatch::File YAML::Tiny File::HomeDir Unicode::GCString

RUN tlmgr install latexindent
