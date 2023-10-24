import time

from safewa import logwa

p=logwa.ProgressBar(100)
for i in range(0,100):
    p.info("abcHHH")
    p.update()
    if i==50:
        p.interrupt()
        break
    time.sleep(0.1)