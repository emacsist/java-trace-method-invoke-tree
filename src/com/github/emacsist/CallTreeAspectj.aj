package com.github.emacsist;

import java.util.Stack;

public aspect CallTreeAspectj {

    public class Trace {
        private final TTree tTree;

        private Trace(TTree tTree) {
            this.tTree = tTree;
        }
    }


    public static final ThreadLocal<Stack<Long>> costTime = new ThreadLocal<Stack<Long>>() {
        @Override
        protected Stack<Long> initialValue() {
            return new Stack<>();
        }
    };

    public static final ThreadLocal<Trace> traceRef = new ThreadLocal<>();


    pointcut callpoint():
            execution(* your.packageName..*.*(..));

    before(): callpoint() {
        String className = thisJoinPoint.getStaticPart().getClass().getSimpleName();
        String methodName = thisJoinPoint.getStaticPart().getSignature().toShortString();

        if (costTime.get().size() == 0) {
            traceRef.set(new Trace(
                            new TTree(true, "Tracing for : " + Thread.currentThread().getName())
                                    .begin(className + ":" + methodName + "()")
                    )
            );
        }

        final Trace trace = traceRef.get();
        long tracingLineNumber = thisJoinPoint.getStaticPart().getSourceLocation().getLine();
        String fileName = thisJoinPoint.getStaticPart().getSourceLocation().getFileName();
        trace.tTree.begin(className + ":" + methodName + "(@" + fileName + ":" + tracingLineNumber + ")");
    }

    after(): callpoint() {
        final Trace trace = traceRef.get();
        if (!trace.tTree.isTop()) {
            trace.tTree.end();
        }
        if (costTime.get().size() == 0) {
            System.out.println(trace.tTree.rendering());
        }
    }

}
