FROM public.ecr.aws/lambda/python:3.10

COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

COPY worker.py ${LAMBDA_TASK_ROOT}

CMD ["worker.lambda_handler"]